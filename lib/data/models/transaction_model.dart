import 'package:drift/drift.dart';
import 'package:zenthory/zenthory.dart';

class TransactionModel {
  final int id;
  final double amount;
  final TransactionType type;
  final int walletId;
  final WalletModel? wallet;
  final ContactModel? contact;
  final int categoryId;
  final int? contactId;
  final CategoryModel? category;
  final DateTime date;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? note;
  final String currency;
  final double currencyRate;
  final bool noImpactOnBalance;
  final List<int> tagIds;
  final List<TagModel>? tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.walletId,
    required this.categoryId,
    required this.currency,
    required this.currencyRate,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.noImpactOnBalance = false,
    this.tagIds = const [],
    this.contactId,
    this.wallet,
    this.contact,
    this.category,
    this.startDate,
    this.endDate,
    this.note,
    this.tags,
  });

  factory TransactionModel.fromEntity(Transaction t) => TransactionModel(
    id: t.id,
    amount: t.amount,
    type: t.type,
    walletId: t.walletId,
    categoryId: t.categoryId,
    contactId: t.contactId,
    date: t.date,
    startDate: t.startDate,
    endDate: t.endDate,
    note: t.note,
    currency: t.currency,
    currencyRate: t.currencyRate,
    noImpactOnBalance: t.noImpactOnBalance,
    createdAt: t.createdAt,
    updatedAt: t.updatedAt,
  );

  Transaction toEntity() => Transaction(
    id: id,
    amount: amount,
    type: type,
    walletId: walletId,
    categoryId: categoryId,
    contactId: contactId,
    date: date,
    startDate: startDate,
    endDate: endDate,
    note: note,
    currency: currency,
    currencyRate: currencyRate,
    noImpactOnBalance: noImpactOnBalance,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  TransactionsCompanion toInsertCompanion() => TransactionsCompanion(
    amount: Value(amount),
    type: Value(type),
    walletId: Value(walletId),
    categoryId: Value(categoryId),
    contactId: Value(contactId),
    date: Value(date),
    startDate: Value(startDate),
    endDate: Value(endDate),
    note: Value(note),
    currency: Value(currency),
    currencyRate: Value(currencyRate),
    noImpactOnBalance: Value(noImpactOnBalance),
    createdAt: Value(createdAt),
    updatedAt: Value(updatedAt),
  );

  TransactionModel copyWith({
    double? amount,
    TransactionType? type,
    int? walletId,
    WalletModel? wallet,
    int? categoryId,
    CategoryModel? category,
    ContactModel? contact,
    int? contactId,
    DateTime? date,
    DateTime? startDate,
    DateTime? endDate,
    String? note,
    String? currency,
    double? currencyRate,
    bool? noImpactOnBalance,
    List<int>? tagIds,
    List<TagModel>? tags,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      walletId: walletId ?? this.walletId,
      wallet: wallet ?? this.wallet,
      contactId: contactId ?? this.contactId,
      contact: contact ?? this.contact,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      date: date ?? this.date,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      note: note ?? this.note,
      currency: currency ?? this.currency,
      currencyRate: currencyRate ?? this.currencyRate,
      noImpactOnBalance: noImpactOnBalance ?? this.noImpactOnBalance,
      tagIds: tagIds ?? this.tagIds,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Money get amountMoney => Money(amount, currency);
}
