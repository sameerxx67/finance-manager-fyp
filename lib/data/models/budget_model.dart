import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class BudgetModel {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int categoryId;
  final CategoryModel? category;
  final WalletModel? wallet;
  final int? walletId;
  final double amount;
  final double spent;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  BudgetModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.categoryId,
    this.category,
    this.walletId,
    this.wallet,
    required this.amount,
    this.spent = 0.0,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.fromEntity(Budget b) {
    return BudgetModel(
      id: b.id,
      name: b.name,
      startDate: b.startDate,
      endDate: b.endDate,
      categoryId: b.categoryId,
      walletId: b.walletId,
      amount: b.amount,
      note: b.note,
      createdAt: b.createdAt,
      updatedAt: b.updatedAt,
    );
  }

  Budget toEntity() {
    return Budget(
      id: id,
      name: name,
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
      walletId: walletId,
      amount: amount,
      note: note,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  BudgetsCompanion toInsertCompanion() {
    return BudgetsCompanion(
      name: Value(name),
      startDate: Value(startDate),
      endDate: Value(endDate),
      categoryId: Value(categoryId),
      walletId: Value(walletId),
      amount: Value(amount),
      note: Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  BudgetModel copyWith({
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    CategoryModel? category,
    int? walletId,
    WalletModel? wallet,
    double? amount,
    double? spent,
    String? note,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      id: id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      walletId: walletId ?? this.walletId,
      wallet: wallet ?? this.wallet,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      note: note ?? this.note,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Money get amountMoney => wallet != null
      ? Money(amount, wallet!.currency)
      : Money.inDefaultCurrency(amount);

  Money get spentMoney => wallet != null
      ? Money(spent, wallet!.currency)
      : Money.inDefaultCurrency(spent);

  Color get progressColor {
    if (progressValue <= 0.5) {
      return appLightColors.success;
    } else if (progressValue <= 0.8) {
      return appLightColors.warning;
    } else {
      return appLightColors.error;
    }
  }

  double get progressValue => (spent / amount).clamp(0.0, 1.0);
}
