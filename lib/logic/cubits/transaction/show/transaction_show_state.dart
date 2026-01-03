part of 'transaction_show_cubit.dart';

sealed class TransactionShowState extends Equatable {
  const TransactionShowState();
}

class TransactionShowLoading extends TransactionShowState {
  @override
  List<Object> get props => [];
}

class TransactionShowLoaded extends TransactionShowState {
  final TransactionModel transaction;

  const TransactionShowLoaded({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class TransactionShowError extends TransactionShowState {
  final ErrorType type;

  const TransactionShowError(this.type);

  @override
  List<Object?> get props => [type];
}

class TransactionShowSuccess extends TransactionShowState {
  final SuccessType type;

  const TransactionShowSuccess(this.type);

  @override
  List<Object?> get props => [type];
}
