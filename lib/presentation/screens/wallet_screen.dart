import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state is WalletError) {
          context.read<SharedCubit>().showDialog(
            type: AlertDialogType.error,
            title: state.type.title(
              context,
              context.tr!.wallets,
              context.tr!.wallet,
            ),
            message: state.type.message(
              context,
              context.tr!.wallets,
              context.tr!.wallet,
            ),
          );
        } else if (state is WalletSuccess) {
          context.read<SharedCubit>().showSnackBar(
            message: state.type == null
                ? state.message!
                : state.type!.message(context, context.tr!.wallet),
          );
        }
      },
      buildWhen: (previous, current) => [
        WalletLoaded,
        WalletLoading,
        WalletError,
      ].any((type) => current.runtimeType == type),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.tr!.manage_wallets),
            actions: [
              if ((state is WalletLoaded) && state.wallets.isNotEmpty)
                IconButton(
                  onPressed: () => _goToForm(context: context),
                  icon: Icon(Icons.add_outlined),
                ),
            ],
          ),
          extendBodyBehindAppBar:
              (state is WalletLoaded && state.wallets.isNotEmpty)
              ? false
              : true,

          body: Builder(
            builder: (context) {
              if (state is WalletLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is WalletLoaded && state.wallets.isNotEmpty) {
                return SafeArea(
                  child: ListView.builder(
                    itemCount: state.wallets.length,
                    padding: const EdgeInsets.all(AppDimensions.padding),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (index == 0)
                            TotalBalance(total: state.totalBalance),
                          WalletTile(
                            wallet: state.wallets[index],
                            hiddenLocked: state.hiddenLocked,
                            onPressedEdit: (WalletModel wallet) =>
                                _goToForm(context: context, wallet: wallet),
                            onPressedSwitchLock: (WalletModel wallet) =>
                                context.read<WalletCubit>().updateWallet(
                                  wallet,
                                  isLocked: !wallet.isLocked,
                                  successMessage: wallet.isLocked
                                      ? context
                                            .tr!
                                            .wallet_unblocked_balance_message
                                      : context
                                            .tr!
                                            .wallet_blocked_balance_message,
                                ),
                            onPressSwitchHidde: (WalletModel wallet) =>
                                context.read<WalletCubit>().updateWallet(
                                  wallet,
                                  isHidden: !wallet.isHidden,
                                  successMessage: wallet.isHidden
                                      ? context
                                            .tr!
                                            .wallet_displayed_balance_message
                                      : context
                                            .tr!
                                            .wallet_hidden_balance_message,
                                ),
                            addBalance: (WalletModel wallet) =>
                                _showDialogAmount(context, wallet, "add"),
                            withdrawBalance: (WalletModel wallet) =>
                                _showDialogAmount(context, wallet, "withdraw"),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
              return PlaceholderView(
                icon: AppIcons.wallets,
                title: context.tr!.wallets_empty_screen_title,
                subtitle: context.tr!.wallets_empty_screen_description,
                actions: [
                  PlaceholderViewAction(
                    title: context.tr!.create_resource(context.tr!.wallet),
                    icon: AppIcons.plus,
                    onTap: () => _goToForm(context: context),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _goToForm({required BuildContext context, WalletModel? wallet}) async {
    final WalletCubit cubit = context.read<WalletCubit>();
    await cubit.formInit(currency: wallet?.currency, type: wallet?.type);
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: WalletFormScreen(wallet: wallet),
        ),
      ),
    );
  }

  void _showDialogAmount(
    BuildContext context,
    WalletModel wallet,
    String action,
  ) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<WalletCubit>(),
        child: WalletDialogAmount(isAdd: action == "add", wallet: wallet),
      ),
    );
  }
}
