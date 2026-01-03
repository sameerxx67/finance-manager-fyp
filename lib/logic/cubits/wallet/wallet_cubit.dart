import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletService service = WalletService();
  final TransactionService transactionService = TransactionService();
  final SharedPreferencesService preferencesService =
      SharedPreferencesService();

  WalletCubit() : super(WalletLoading());

  Future<void> loadWallets() async {
    try {
      final List<WalletModel> wallets = await service.fetchAll();
      int numberOfLocked = 0;
      Money totalBalance = Money.inDefaultCurrency(0);
      for (var wallet in wallets) {
        if (!wallet.isLocked && !wallet.isHidden) {
          totalBalance = totalBalance.add(
            await wallet.balanceMoney.convertToDefaultCurrency(),
          );
        }
        if (wallet.isLocked) {
          numberOfLocked += 1;
        }
      }
      emit(
        WalletLoaded(
          wallets: wallets,
          totalBalance: totalBalance,
          hiddenLocked: numberOfLocked >= (wallets.length - 1),
        ),
      );
    } catch (e) {
      emit(WalletError(ErrorType.failedToLoad));
    }
  }

  Future<void> formInit({WalletType? type, String? currency}) async => emit(
    WalletFormInitial(
      type: type ?? WalletType.cash,
      currency: currency ?? (await preferencesService.getCurrency()),
    ),
  );

  void setData({WalletType? type, String? currency}) {
    if (state is WalletFormInitial) {
      emit(
        (state as WalletFormInitial).copyWith(currency: currency, type: type),
      );
    }
  }

  Future<WalletModel?> _addWallet(
    String name,
    double balance,
    WalletType type,
    String currency,
  ) async {
    try {
      final now = DateTime.now();
      final newWallet = WalletModel(
        id: 0,
        name: name,
        type: type,
        balance: balance,
        currency: currency,
        isLocked: false,
        isHidden: false,
        createdAt: now,
        updatedAt: now,
      );
      final int walletId = await service.create(newWallet);
      await loadWallets();
      emit(WalletSuccess(type: SuccessType.created));
      return newWallet.copyWith(id: walletId);
    } catch (e) {
      emit(WalletError(ErrorType.failedToAdd));
      return null;
    }
  }

  Future<WalletModel?> updateWallet(
    WalletModel wallet, {
    String? name,
    double? balance,
    bool? isLocked,
    bool? isHidden,
    String? currency,
    String? successMessage,
  }) async {
    try {
      final WalletModel newWallet = wallet.copyWith(
        name: name,
        balance: balance,
        currency: currency,
        isLocked: isLocked,
        isHidden: isHidden,
        updatedAt: DateTime.now(),
      );
      await service.update(newWallet);
      await loadWallets();
      emit(
        WalletSuccess(
          type: successMessage == null ? SuccessType.updated : null,
          message: successMessage,
        ),
      );
      return newWallet;
    } catch (e) {
      emit(WalletError(ErrorType.failedToUpdate));
      return null;
    }
  }

  Future<bool> _validationForm(
    WalletFormInitial formInitial,
    Map<String, String> errorMessages,
    int id,
    String? name,
    WalletType? type,
    double? balance,
  ) async {
    Map<String, String> errors = {};

    if (name == null || name.trim().isEmpty) {
      errors['name'] = errorMessages['name_is_required']!;
    } else if (name.length < 2 || name.length > 50) {
      errors['name'] =
          errorMessages['name_should_be_between_min_to_max_characters']!;
    } else if (await service.nameExists(name, excludeId: id)) {
      errors['name'] = errorMessages['this_name_is_already_used']!;
    }

    if (type == null) {
      errors['type'] = errorMessages['type_is_required']!;
    }

    if (errors.isNotEmpty) {
      emit(formInitial.copyWith(errors: errors));
      return false;
    } else {
      return true;
    }
  }

  Future<bool> submit(
    Map<String, String> errorMessages,
    WalletModel? wallet,
    String? name,
    double? balance,
  ) async {
    final WalletFormInitial formInitial = (state as WalletFormInitial);

    if (await _validationForm(
      formInitial,
      errorMessages,
      wallet == null ? 0 : wallet.id,
      name,
      formInitial.type,
      balance,
    )) {
      emit(formInitial.copyWith(processing: true));

      WalletModel? newWallet;
      if (wallet == null) {
        newWallet = await _addWallet(
          name!,
          balance ?? 0,
          formInitial.type!,
          formInitial.currency,
        );
        if (newWallet != null && newWallet.balance > 0) {
          await transactionService.createAddBalanceTransaction(
            wallet: newWallet,
            amount: newWallet.balance,
          );
        }
      } else {
        newWallet = await updateWallet(
          wallet,
          name: name,
          balance: balance,
          currency: formInitial.currency,
        );
        final newBalance = balance ?? 0;
        if (newWallet != null && wallet.balance != newBalance) {
          if (newBalance > wallet.balance) {
            await transactionService.createAddBalanceTransaction(
              wallet: newWallet,
              amount: newBalance - wallet.balance,
            );
          } else {
            await transactionService.createWithdrawBalanceTransaction(
              wallet: newWallet,
              amount: wallet.balance - newBalance,
            );
          }
        }
      }

      emit(formInitial.copyWith(processing: false, errors: {}));
      return newWallet != null;
    }
    return false;
  }

  Future<bool> addBalance({
    required WalletModel wallet,
    required double amount,
    required String successMessage,
  }) async {
    try {
      await transactionService.createAddBalanceTransaction(
        wallet: wallet,
        amount: amount,
      );
      await loadWallets();
      emit(WalletSuccess(message: successMessage));
      return true;
    } catch (e) {
      emit(WalletError(ErrorType.failedToAddBalance));
      return false;
    }
  }

  Future<bool> withdrawBalance({
    required WalletModel wallet,
    required double amount,
    required String successMessage,
  }) async {
    try {
      await transactionService.createWithdrawBalanceTransaction(
        wallet: wallet,
        amount: amount,
      );
      await loadWallets();
      emit(WalletSuccess(message: successMessage));
      return true;
    } catch (e) {
      emit(WalletError(ErrorType.failedToWithdrawBalance));
      return false;
    }
  }
}
