import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

part 'transaction_show_state.dart';

class TransactionShowCubit extends Cubit<TransactionShowState> {
  final TransactionService service = TransactionService();

  TransactionShowCubit() : super(TransactionShowLoading());

  Future<void> get(int id) async {
    try {
      emit(TransactionShowLoaded(transaction: (await service.find(id))!));
    } catch (e) {
      emit(TransactionShowError(ErrorType.failedToLoad));
    }
  }

  void delete(TransactionModel transaction) async {
    try {
      await service.delete(transaction);
      emit(TransactionShowSuccess(SuccessType.deleted));
    } catch (e) {
      emit(TransactionShowError(ErrorType.failedToDelete));
    }
  }
}
