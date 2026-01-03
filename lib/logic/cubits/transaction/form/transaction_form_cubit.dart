import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

part 'transaction_form_state.dart';

class TransactionFormCubit extends Cubit<TransactionFormState> {
  final TransactionService service = TransactionService();
  final WalletService walletService = WalletService();
  final CategoryService categoryService = CategoryService();
  final TagService tagService = TagService();

  TransactionFormCubit() : super(TransactionFormLoading());

  Future<void> init({
    TransactionModel? transaction,
    required TransactionType type,
  }) async {
    final List<WalletModel> wallets = await walletService.fetchAll(
      isLocked: false,
    );
    final List<CategoryModel> categories = await categoryService.getGrouped(
      type: type,
    );
    final WalletModel lastWallet = wallets.first;
    emit(
      TransactionFormInitial(
        wallets: wallets,
        categories: categories,
        tags: await tagService.fetchAll(),
        type: type,
        walletId: transaction?.walletId ?? lastWallet.id,
        categoryId: transaction?.categoryId ?? categories.first.id,
        contactId: transaction?.contactId,
        date: transaction?.date ?? DateTime.now(),
        startDate:
            transaction?.startDate ??
            (type == TransactionType.debts ? DateTime.now() : null),
        endDate:
            transaction?.endDate ??
            (type == TransactionType.debts ? DateTime.now() : null),
        contact: transaction?.contact,
        currency: transaction?.currency ?? lastWallet.currency,
        noImpactOnBalance: transaction?.noImpactOnBalance ?? false,
        tagIds: transaction?.tagIds ?? [],
      ),
    );
  }

  Future<void> setData({
    List<WalletModel>? wallets,
    List<CategoryModel>? categories,
    List<TagModel>? tags,
    TransactionType? type,
    int? walletId,
    int? categoryId,
    int? contactId,
    ContactModel? contact,
    List<int>? tagIds,
    DateTime? date,
    DateTime? startDate,
    DateTime? endDate,
    String? currency,
    double? currencyRate,
    bool? noImpactOnBalance,
    bool? processing,
    Map<String, String>? errors,
    bool loadCategories = false,
  }) async {
    if (state is TransactionFormInitial) {
      emit(
        (state as TransactionFormInitial).copyWith(
          wallets: wallets,
          tags: tags,
          categories: loadCategories
              ? await categoryService.getGrouped(type: type)
              : null,
          type: type,
          walletId: walletId,
          categoryId: categoryId,
          contactId: contactId,
          contact: contact,
          startDate: startDate,
          endDate: endDate,
          tagIds: tagIds,
          date: date,
          currency: walletId != null
              ? (state as TransactionFormInitial).wallets
                    .firstWhere((w) => w.id == walletId)
                    .currency
              : currency,
          currencyRate: currencyRate,
          noImpactOnBalance: noImpactOnBalance,
          processing: processing,
          errors: errors,
        ),
      );
    }
  }

  Future<bool> _addTransaction(TransactionModel transaction) async {
    try {
      await service.create(transaction);
      emit(TransactionFormSuccess(SuccessType.created));
      return true;
    } catch (e) {
      emit(TransactionFormError(ErrorType.failedToAdd));
      return false;
    }
  }

  Future<bool> _updateTransaction(
    TransactionModel transaction,
    TransactionModel oldTransaction,
  ) async {
    try {
      await service.update(transaction, oldTransaction);
      emit(TransactionFormSuccess(SuccessType.updated));
      return true;
    } catch (e) {
      emit(TransactionFormError(ErrorType.failedToUpdate));
      return false;
    }
  }

  Future<bool> submit(
    Map<String, String> errorMessages,
    TransactionModel? transaction,
    double? amount,
    String? note,
  ) async {
    final TransactionFormInitial form = (state as TransactionFormInitial);
    bool isSubmitted = false;
    if (await _validationForm(form, errorMessages, amount)) {
      emit(form.copyWith(processing: true));
      final now = DateTime.now();

      double currencyRate = transaction?.currencyRate ?? 1.0;
      if (transaction == null ||
          transaction.currency != form.currency ||
          transaction.amount != amount) {
        currencyRate = await CurrencyRateUtils.forCurrency(form.currency!);
      }

      final model = TransactionModel(
        id: transaction?.id ?? 0,
        note: note,
        amount: amount!,
        walletId: form.walletId!,
        type: form.type!,
        date: form.date!,
        startDate: form.startDate,
        endDate: form.endDate,
        categoryId: form.categoryId!,
        contactId: form.contactId,
        tagIds: form.tagIds,
        currency: form.currency!,
        currencyRate: currencyRate,
        noImpactOnBalance: form.noImpactOnBalance,
        createdAt: transaction?.createdAt ?? now,
        updatedAt: now,
      );

      isSubmitted = await (transaction == null
          ? _addTransaction(model)
          : _updateTransaction(model, transaction));

      emit(form.copyWith(processing: false, errors: {}));
    }
    return isSubmitted;
  }

  Future<bool> _validationForm(
    TransactionFormInitial form,
    Map<String, String> errorMessages,
    double? amount,
  ) async {
    Map<String, String> errors = {};

    if (form.type == null) {
      errors['type'] = errorMessages['type_is_required']!;
    }
    if (amount == null) {
      errors['amount'] = errorMessages['amount_is_required']!;
    } else if (amount < 1) {
      errors['amount'] = errorMessages['amount_must_be_greater_than']!;
    }

    if (form.categoryId == null) {
      errors['category_id'] = errorMessages['category_is_required']!;
    }

    if (form.walletId == null) {
      errors['wallet_id'] = errorMessages['wallet_is_required']!;
    }
    if (form.date == null) {
      errors['date'] = errorMessages['date_is_required']!;
    }

    if (form.type == TransactionType.debts && form.startDate == null) {
      errors['start_date'] = errorMessages['start_date_is_required']!;
    }

    if (form.type == TransactionType.debts && form.endDate == null) {
      errors['end_date'] = errorMessages['end_date_is_required']!;
    }

    if (form.type == TransactionType.debts && form.contactId == null) {
      errors['contact'] = errorMessages['contact_is_required']!;
    }

    if (errors.isNotEmpty) {
      emit(form.copyWith(errors: errors));
      return false;
    } else {
      return true;
    }
  }
}
