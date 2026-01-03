part of 'transaction_cubit.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();
}

class TransactionLoading extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionLoaded extends TransactionState {
  final CategoryModel? category;
  final ContactModel? contact;
  final TransactionType? type;
  final int? walletId;
  final List<int>? tagIds;
  final List<TagModel> tags;
  final DateTimeRange? dateRange;
  final List<WalletModel> wallets;
  final bool hasMore;
  final int offset;
  final List<TransactionGroupedByDateModel> transactions;

  const TransactionLoaded({
    required this.transactions,
    required this.wallets,
    required this.tags,
    this.category,
    this.contact,
    this.type,
    this.walletId,
    this.tagIds,
    this.dateRange,
    this.hasMore = true,
    this.offset = 0,
  });

  TransactionLoaded copyWith({
    List<TransactionGroupedByDateModel>? transactions,
    bool? hasMore,
    int? offset,
    CategoryModel? category,
    ContactModel? contact,
    TransactionType? type,
    int? walletId,
    List<int>? tagIds,
    DateTimeRange? dateRange,
    List<WalletModel>? wallets,
    List<TagModel>? tags,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      category: category ?? this.category,
      contact: contact ?? this.contact,
      type: type ?? this.type,
      walletId: walletId ?? this.walletId,
      dateRange: dateRange ?? this.dateRange,
      wallets: wallets ?? this.wallets,
      tags: tags ?? this.tags,
      tagIds: tagIds ?? this.tagIds,
    );
  }

  @override
  List<Object?> get props => [
    transactions,
    wallets,
    category,
    contact,
    type,
    walletId,
    dateRange,
    hasMore,
    offset,
    tags,
    tagIds,
  ];
}

class TransactionError extends TransactionState {
  final ErrorType type;

  const TransactionError(this.type);

  @override
  List<Object?> get props => [type];
}

class TransactionSuccess extends TransactionState {
  final SuccessType type;

  const TransactionSuccess(this.type);

  @override
  List<Object?> get props => [type];
}
