part of 'contact_cubit.dart';

sealed class ContactState extends Equatable {
  const ContactState();
}

class ContactLoading extends ContactState {
  @override
  List<Object> get props => [];
}

class ContactLoaded extends ContactState {
  final List<ContactModel> contacts;

  const ContactLoaded(this.contacts);

  @override
  List<Object> get props => [contacts];
}

class ContactError extends ContactState {
  final ErrorType type;

  const ContactError(this.type);

  @override
  List<Object> get props => [type];
}

class ContactSuccess extends ContactState {
  final SuccessType type;

  const ContactSuccess(this.type);

  @override
  List<Object> get props => [type];
}

final class ContactFormInitial extends ContactState {
  final bool processing;
  final Map<String, String> errors;

  const ContactFormInitial({this.processing = false, this.errors = const {}});

  ContactFormInitial copyWith({bool? processing, Map<String, String>? errors}) {
    return ContactFormInitial(
      processing: processing ?? this.processing,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [errors, processing];
}
