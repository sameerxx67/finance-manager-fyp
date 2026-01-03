import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

enum WalletType {
  cash,
  bank,
  eWallet,
  creditCard,
  investment,
  other;

  String toTrans(BuildContext context) {
    switch (this) {
      case cash:
        return context.tr!.cash;
      case bank:
        return context.tr!.bank;
      case creditCard:
        return context.tr!.credit_card;
      case eWallet:
        return context.tr!.e_wallet;
      case investment:
        return context.tr!.investment;
      case other:
        return context.tr!.other;
    }
  }

  Color get color {
    switch (this) {
      case cash:
        return Color(0XFF16a085);
      case bank:
        return Color(0XFF2980b9);
      case creditCard:
        return Color(0XFF8e44ad);
      case eWallet:
        return Color(0XFF22a6b3);
      case investment:
        return Color(0XFFbe2edd);
      case other:
        return Color(0XFFc0392b);
    }
  }

  String get icon {
    switch (this) {
      case cash:
        return AppIcons.cash;
      case bank:
        return AppIcons.bank;
      case creditCard:
        return AppIcons.creditCard;
      case eWallet:
        return AppIcons.eWallet;
      case investment:
        return AppIcons.investment;
      case other:
        return AppIcons.walletTypeOther;
    }
  }

  String get image {
    switch (this) {
      case cash:
        return AppImages.cash;
      case bank:
        return AppImages.bank;
      case creditCard:
        return AppImages.creditCard;
      case eWallet:
        return AppImages.eWallet;
      case investment:
        return AppImages.investment;
      case other:
        return AppImages.walletOther;
    }
  }
}
