import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactService service = ContactService();

  ContactCubit() : super(ContactLoading());

  Future<void> loadContacts() async {
    try {
      emit(ContactLoaded(await service.fetchAll()));
    } catch (e) {
      emit(ContactError(ErrorType.failedToLoad));
    }
  }

  void deleteContact(ContactModel contact) async {
    try {
      await service.delete(contact.id);
      await loadContacts();
      emit(ContactSuccess(SuccessType.deleted));
    } catch (e) {
      emit(ContactError(ErrorType.failedToDelete));
    }
  }

  Future<bool> _addContact(ContactModel contact) async {
    try {
      await service.create(contact);
      await loadContacts();
      emit(ContactSuccess(SuccessType.created));
      return true;
    } catch (e) {
      emit(ContactError(ErrorType.failedToAdd));
      return false;
    }
  }

  Future<bool> _updateContact(ContactModel contact) async {
    try {
      await service.update(contact);
      await loadContacts();
      emit(ContactSuccess(SuccessType.updated));
      return true;
    } catch (e) {
      emit(ContactError(ErrorType.failedToUpdate));
      return false;
    }
  }

  void formInit() async =>
      emit(ContactFormInitial(errors: {}, processing: false));

  Future<void> setData({String? color, Map<String, String>? errors}) async {
    if (state is ContactFormInitial) {
      emit((state as ContactFormInitial).copyWith(errors: errors));
    }
  }

  Future<bool> submit(
    Map<String, String> errorMessages,
    ContactModel? contact,
    String? name,
    String? note,
  ) async {
    final ContactFormInitial formInitial = (state as ContactFormInitial);
    bool isSubmitted = false;
    if (await _validationForm(
      formInitial,
      errorMessages,
      contact == null ? 0 : contact.id,
      name,
    )) {
      final now = DateTime.now();

      final model = ContactModel(
        id: contact?.id ?? 0,
        name: name!,
        note: note,
        color: contact?.color ?? ColorUtils.generateRandomColorHex(),
        createdAt: contact?.createdAt ?? now,
        updatedAt: now,
      );

      isSubmitted = await (contact == null
          ? _addContact(model)
          : _updateContact(model));

      emit(formInitial.copyWith(processing: false, errors: {}));
    }
    return isSubmitted;
  }

  Future<bool> _validationForm(
    ContactFormInitial formInitial,
    Map<String, String> errorMessages,
    int id,
    String? name,
  ) async {
    Map<String, String> errors = {};

    if (name == null || name.trim().isEmpty) {
      errors['name'] = errorMessages['name_is_required']!;
    } else if (name.length < 2 || name.length > 30) {
      errors['name'] =
          errorMessages['name_should_be_between_min_to_max_characters']!;
    } else if (await service.nameExists(name, excludeId: id)) {
      errors['name'] = errorMessages['this_name_is_already_used']!;
    }

    if (errors.isNotEmpty) {
      emit(formInitial.copyWith(errors: errors));
      return false;
    } else {
      return true;
    }
  }
}
