part of 'wallet_cubit.dart';

sealed class WalletState extends Equatable {
  const WalletState();
}

class WalletLoading extends WalletState {
  @override
  List<Object> get props => [];
}

class WalletLoaded extends WalletState {
  final List<WalletModel> wallets;
  final Money totalBalance;
  final bool hiddenLocked;

  const WalletLoaded({
    required this.wallets,
    required this.totalBalance,
    this.hiddenLocked = false,
  });

  @override
  List<Object?> get props => [wallets, totalBalance];
}

class WalletError extends WalletState {
  final ErrorType type;

  const WalletError(this.type);

  @override
  List<Object?> get props => [type];
}

class WalletSuccess extends WalletState {
  final SuccessType? type;
  final String? message;

  const WalletSuccess({this.type, this.message})
    : assert(
        type != null || message != null,
        'Either "type" or "message" must be provided.',
      ),
      assert(
        (type != null) != (message != null),
        'Exactly one of "type" or "message" must be provided, not both or neither.',
      );

  @override
  List<Object?> get props => [type, message];
}

final class WalletFormInitial extends WalletState {
  final WalletType? type;
  final String currency;
  final bool processing;
  final Map<String, String> errors;

  const WalletFormInitial({
    required this.currency,
    this.processing = false,
    this.errors = const {},
    this.type,
  });

  WalletFormInitial copyWith({
    WalletType? type,
    String? currency,
    bool? processing,
    Map<String, String>? errors,
  }) {
    return WalletFormInitial(
      type: type ?? this.type,
      currency: currency ?? this.currency,
      processing: processing ?? this.processing,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [errors, type, currency, processing];
}
