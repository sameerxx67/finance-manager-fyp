part of 'tag_cubit.dart';

sealed class TagState extends Equatable {
  const TagState();
}

class TagLoading extends TagState {
  @override
  List<Object> get props => [];
}

class TagLoaded extends TagState {
  final List<TagModel> tags;

  const TagLoaded(this.tags);

  @override
  List<Object?> get props => [tags];
}

class TagError extends TagState {
  final ErrorType type;

  const TagError(this.type);

  @override
  List<Object?> get props => [type];
}

class TagSuccess extends TagState {
  final SuccessType type;

  const TagSuccess(this.type);

  @override
  List<Object?> get props => [type];
}

final class TagFormInitial extends TagState {
  final String color;
  final bool processing;
  final Map<String, String> errors;

  const TagFormInitial({
    required this.color,
    this.processing = false,
    this.errors = const {},
  });

  TagFormInitial copyWith({
    String? color,
    bool? processing,
    Map<String, String>? errors,
  }) {
    return TagFormInitial(
      color: color ?? this.color,
      processing: processing ?? this.processing,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object> get props => [color, errors, processing];
}
