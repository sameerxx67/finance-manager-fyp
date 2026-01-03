import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class TransactionFilterModalBottomSheet extends StatefulWidget {
  final CategoryModel? category;
  final ContactModel? contact;
  final TransactionType? type;
  final int? walletId;
  final DateTimeRange? dateRange;
  final List<WalletModel> wallets;
  final List<TagModel> tags;
  final List<int>? tagIds;
  final Function({
    CategoryModel? category,
    ContactModel? contact,
    TransactionType? type,
    int? walletId,
    DateTimeRange? dateRange,
    List<int>? tagIds,
  })
  onChange;

  const TransactionFilterModalBottomSheet({
    super.key,
    this.category,
    this.type,
    this.walletId,
    this.dateRange,
    this.contact,
    required this.onChange,
    required this.wallets,
    required this.tags,
    this.tagIds,
  });

  @override
  State<TransactionFilterModalBottomSheet> createState() =>
      _TransactionFilterModalBottomSheetState();
}

class _TransactionFilterModalBottomSheetState
    extends State<TransactionFilterModalBottomSheet> {
  CategoryModel? category;
  ContactModel? contact;
  TransactionType? type;
  int? walletId;
  List<int>? tagIds;
  DateTimeRange? dateRange;

  @override
  void initState() {
    super.initState();
    setState(() {
      category = widget.category;
      type = widget.type;
      walletId = widget.walletId;
      dateRange = widget.dateRange;
      tagIds = widget.tagIds;
      contact = widget.contact;
    });
  }

  void _onChange({
    CategoryModel? category,
    ContactModel? contact,
    TransactionType? type,
    int? walletId,
    List<int>? tagIds,
    DateTimeRange? dateRange,
  }) {
    widget.onChange(
      category: category ?? this.category,
      contact: contact ?? this.contact,
      type: type ?? this.type,
      tagIds: tagIds ?? this.tagIds,
      walletId: walletId ?? this.walletId,
      dateRange: dateRange ?? this.dateRange,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgIcon(
                    icon: AppIcons.filters,
                    width: 18,
                    color: context.colors.textPrimary,
                  ),
                  SizedBox(width: 5),
                  Text(
                    context.tr!.transactions_filter,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  widget.onChange();
                  Navigator.pop(context);
                },
                child: Text(
                  context.tr!.reset,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        CustomDropdownMenu(
          label: context.tr!.type,
          options: TransactionType.values
              .map(
                (TransactionType type) => CustomDropdownMenuOption(
                  id: type,
                  name: type.toTrans(context),
                  icon: type.icon,
                  color: type.color,
                ),
              )
              .toList(),
          defaultIcon: AppIcons.transaction,
          selectedId: widget.type,
          onSelect: (dynamic id) {
            setState(() {
              type = id;
            });
            _onChange(type: id);
          },
        ),
        FullCategoryPicker(
          label: context.tr!.category,
          selectedCategory: widget.category,
          hasDivider: true,
          margin: EdgeInsets.zero,
          onPicked: (CategoryModel category) {
            setState(() {
              category = category;
            });
            _onChange(category: category);
          },
        ),
        CustomDropdownMenu(
          label: context.tr!.wallet,
          options: widget.wallets
              .map(
                (WalletModel wallet) => CustomDropdownMenuOption(
                  id: wallet.id,
                  name: wallet.name,
                  subtitle: wallet.type.toTrans(context),
                  trailingText: wallet.balanceMoney.format(),
                  icon: wallet.type.icon,
                  color: wallet.type.color,
                ),
              )
              .toList(),
          defaultIcon: AppIcons.wallets,
          selectedId: widget.walletId,
          onSelect: (dynamic id) {
            setState(() {
              walletId = id;
            });
            _onChange(walletId: id);
          },
        ),
        CustomDateRangePicker(
          label: context.tr!.date_range,
          startDate: widget.dateRange?.start,
          endDate: widget.dateRange?.end,
          onPicked: (DateTimeRange range) {
            setState(() {
              dateRange = range;
            });
            _onChange(dateRange: range);
          },
        ),
        ContactPicker(
          selectedContact: contact,
          onPicked: (ContactModel newContact) {
            setState(() {
              contact = newContact;
            });
            _onChange(contact: newContact);
          },
        ),
        CustomDropdownMenu(
          label: context.tr!.tags,
          defaultIcon: AppIcons.tags,
          isMultiple: true,
          hiddenLeading: true,
          options: widget.tags
              .map(
                (TagModel tag) =>
                    CustomDropdownMenuOption(id: tag.id, name: tag.name),
              )
              .toList(),
          selectedId: tagIds,
          onSelect: (dynamic ids) {
            final List<int> newIds = (ids as List).cast<int>();
            setState(() {
              tagIds = newIds;
            });
            _onChange(tagIds: newIds);
          },
        ),
      ],
    );
  }
}
