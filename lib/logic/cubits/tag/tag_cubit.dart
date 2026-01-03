import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

part 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  final TagService service = TagService();

  TagCubit() : super(TagLoading());

  Future<void> loadTags() async {
    try {
      emit(TagLoaded(await service.fetchAll()));
    } catch (e) {
      emit(TagError(ErrorType.failedToLoad));
    }
  }

  void deleteTag(int id) async {
    try {
      await service.delete(id);
      await loadTags();
      emit(TagSuccess(SuccessType.deleted));
    } catch (e) {
      emit(TagError(ErrorType.failedToDelete));
    }
  }

  void formInit({String? color}) async => emit(
    TagFormInitial(
      color: color ?? AppStrings.defaultColorPicked,
      processing: false,
    ),
  );

  void setColor(String color) {
    if (state is TagFormInitial) {
      emit((state as TagFormInitial).copyWith(color: color));
    }
  }

  Future<bool> submit(
    Map<String, String> errorMessages,
    TagModel? tag,
    String? name,
  ) async {
    final TagFormInitial formInitial = (state as TagFormInitial);
    final String color = formInitial.color;
    bool isSubmitted = false;
    if (await _validationForm(
      formInitial,
      errorMessages,
      tag == null ? 0 : tag.id,
      name,
    )) {
      emit(formInitial.copyWith(processing: true, errors: {}));
      if (tag == null) {
        isSubmitted = await _addTag(name!, color);
      } else {
        isSubmitted = await _updateTag(tag, name!, color);
      }
      emit(formInitial.copyWith(processing: false));
    }
    return isSubmitted;
  }

  Future<bool> _addTag(String name, String color) async {
    try {
      final now = DateTime.now();
      await service.create(
        TagModel(
          id: 0,
          name: name,
          color: color,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await loadTags();
      emit(TagSuccess(SuccessType.created));
      return true;
    } catch (e) {
      emit(TagError(ErrorType.failedToAdd));
      return false;
    }
  }

  Future<bool> _updateTag(TagModel tag, String name, String color) async {
    try {
      await service.update(
        tag.copyWith(name: name, color: color, updatedAt: DateTime.now()),
      );
      await loadTags();
      emit(TagSuccess(SuccessType.updated));
      return true;
    } catch (e) {
      emit(TagError(ErrorType.failedToUpdate));
      return false;
    }
  }

  Future<bool> _validationForm(
    TagFormInitial formInitial,
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
