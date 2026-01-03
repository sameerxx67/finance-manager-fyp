import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/core/core.dart';
import 'package:zenthory/data/data.dart';
import 'package:zenthory/logic/cubits/shared/shared_cubit.dart';
import 'package:zenthory/presentation/presentation.dart';

class WalletTile extends StatelessWidget {
  final Function(WalletModel wallet)? onPressedEdit;
  final Function(WalletModel wallet)? onPressSwitchHidde;
  final Function(WalletModel wallet)? onPressedSwitchLock;
  final Function(WalletModel wallet)? addBalance;
  final Function(WalletModel wallet)? withdrawBalance;

  final WalletModel wallet;
  final bool onlyView;
  final bool hiddenLocked;

  const WalletTile({
    super.key,
    required this.wallet,
    this.onPressedEdit,
    this.onPressedSwitchLock,
    this.onPressSwitchHidde,
    this.addBalance,
    this.withdrawBalance,
    this.onlyView = false,
    this.hiddenLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onlyView ? null : () => _openMenuActions(context),
          child: Container(
            height: 160,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(wallet.type.image),
                fit: BoxFit.cover,
              ),
              color: wallet.type.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: onlyView
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    if (!onlyView)
                      SvgIcon(
                        icon: AppIcons.angleSmallDown,
                        color: Colors.white,
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          wallet.name.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        SvgIcon(
                          icon: wallet.type.icon,
                          color: Colors.white,
                          width: 22,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wallet.balanceMoney.format(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                        decoration: wallet.isHidden
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: Colors.white,
                      ),
                    ),
                    Text(
                      context.tr!.current_balance,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      wallet.type.toTrans(context).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Visibility(
                      visible: !onlyView,
                      child: Row(
                        children: [
                          if (onPressSwitchHidde != null)
                            IconButton(
                              onPressed: () => onPressSwitchHidde!(wallet),
                              icon: SvgIcon(
                                icon: wallet.isHidden
                                    ? AppIcons.crossedEye
                                    : AppIcons.eye,
                                color: Colors.white,
                                width: 20,
                              ),
                            ),
                          if ((!hiddenLocked && onPressedSwitchLock != null) ||
                              wallet.isLocked)
                            IconButton(
                              onPressed: () => onPressedSwitchLock!(wallet),
                              icon: SvgIcon(
                                icon: wallet.isLocked
                                    ? AppIcons.unlock
                                    : AppIcons.unlock,
                                color: Colors.white,
                                width: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (!onlyView && wallet.isLocked)
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        if (!onlyView && onPressedSwitchLock != null && wallet.isLocked)
          Positioned(
            bottom: 15.5,
            right: 14.5,
            child: IconButton(
              onPressed: () => onPressedSwitchLock!(wallet),
              icon: SvgIcon(
                icon: AppIcons.lock,
                color: Colors.white,
                width: 20,
              ),
            ),
          ),
      ],
    );
  }

  void _openMenuActions(BuildContext context) {
    context.read<SharedCubit>().showModalBottomSheet(
      (context) => ActionsModalBottomSheet(
        actions: [
          if (addBalance != null)
            ActionModalBottomSheet(
              icon: AppIcons.addBalance,
              title: context.tr!.add_balance,
              onTap: () => addBalance!(wallet),
            ),
          if (withdrawBalance != null)
            ActionModalBottomSheet(
              icon: AppIcons.withdrawBalance,
              title: context.tr!.withdraw_balance,
              onTap: () => withdrawBalance!(wallet),
            ),
          if (onPressedEdit != null)
            ActionModalBottomSheet(
              icon: AppIcons.edit,
              title: context.tr!.edit_resource(context.tr!.wallet),
              iconColor: context.colors.success,
              onTap: () => onPressedEdit!(wallet),
            ),
        ],
      ),
    );
  }
}
