import 'package:drift/drift.dart';
import 'package:zenthory/zenthory.dart';

class WalletModel {
  final int id;
  final String name;
  final WalletType type;
  final String currency;
  final double balance;
  final bool isLocked;
  final bool isHidden;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletModel({
    required this.id,
    required this.name,
    required this.type,
    required this.currency,
    required this.balance,
    required this.isLocked,
    required this.isHidden,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletModel.fromEntity(Wallet w) {
    return WalletModel(
      id: w.id,
      name: w.name,
      type: w.type,
      currency: w.currency,
      balance: w.balance,
      isLocked: w.isLocked,
      isHidden: w.isHidden,
      createdAt: w.createdAt,
      updatedAt: w.updatedAt,
    );
  }

  Wallet toEntity() {
    return Wallet(
      id: id,
      name: name,
      type: type,
      currency: currency,
      balance: balance,
      isLocked: isLocked,
      isHidden: isHidden,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  WalletsCompanion toInsertCompanion() {
    return WalletsCompanion(
      name: Value(name),
      type: Value(type),
      currency: Value(currency),
      balance: Value(balance),
      isLocked: Value(isLocked),
      isHidden: Value(isHidden),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  WalletModel copyWith({
    int? id,
    String? name,
    WalletType? type,
    String? currency,
    double? balance,
    bool? isLocked,
    bool? isHidden,
    DateTime? updatedAt,
  }) {
    return WalletModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
      isLocked: isLocked ?? this.isLocked,
      isHidden: isHidden ?? this.isHidden,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Money get balanceMoney => Money(balance, currency);
}
