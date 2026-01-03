import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class BudgetFormScreen extends StatefulWidget {
  final BudgetModel? budget;

  const BudgetFormScreen({super.key, this.budget});

  @override
  State<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends State<BudgetFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _rangeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.budget != null) {
      _nameController.text = widget.budget!.name;
      _amountController.text = widget.budget!.amount.toString();
      if (widget.budget!.note != null) {
        _noteController.text = widget.budget!.note!;
      }
    }

    _rangeController.text = context.read<SharedCubit>().formatRange(
      widget.budget?.startDate ?? DateTime.now(),
      widget.budget?.endDate ??
          DateTime.now().add(
            const Duration(days: AppStrings.defaultBudgetDurationDays),
          ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _rangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetCubit, BudgetState>(
      buildWhen: (previous, current) =>
          current.runtimeType == BudgetFormInitial,
      builder: (context, state) {
        if (state is BudgetFormInitial) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.budget == null
                    ? context.tr!.create_resource(context.tr!.budget)
                    : context.tr!.update_resource(context.tr!.budget),
              ),
            ),
            bottomNavigationBar: FormBottomNavigationBar(
              okButtonOnPressed: () async {
                if (await context.read<BudgetCubit>().submit(
                  {
                    "name_is_required": context.tr!.attribute_is_required(
                      context.tr!.name,
                    ),
                    "name_should_be_between_min_to_max_characters": context.tr!
                        .attribute_should_be_between_min_to_max_characters(
                          context.tr!.name,
                          50,
                          2,
                        ),
                    "category_is_required": context.tr!.attribute_is_required(
                      context.tr!.category,
                    ),
                    "amount_is_required": context.tr!.attribute_is_required(
                      context.tr!.amount,
                    ),
                    "end_date_must_be_after_start_date":
                        context.tr!.end_date_must_be_after_start_date,
                    "note_must_not_exceed_number_characters": context.tr!
                        .attribute_must_not_exceed_number_characters(
                          context.tr!.note,
                          200,
                        ),
                    "amount_must_be_greater_than": context.tr!
                        .attribute_must_be_greater_than_number(
                          context.tr!.amount,
                          0,
                        ),
                  },
                  widget.budget,
                  _nameController.text,
                  double.tryParse(_amountController.text),
                  _noteController.text,
                )) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                }
              },
              okButtonLoading: state.processing,
              okButtonText: widget.budget == null
                  ? context.tr!.create
                  : context.tr!.update,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CategoryPicker(
                    label: context.tr!.category,
                    categories: state.categories,
                    errorText: state.errors['category'],
                    selectedId: state.categoryId,
                    onPicked: (CategoryModel category) {
                      _nameController.text = category.name;
                      context.read<BudgetCubit>().setData(
                        categoryId: category.id,
                      );
                    },
                  ),
                  ContainerForm(
                    margin: EdgeInsets.only(
                      bottom: AppDimensions.inputBottomMargin,
                    ),
                    child: Column(
                      children: [
                        CustomTextFormField(
                          label: context.tr!.name,
                          controller: _nameController,
                          hintText: context.tr!.enter_resource_name(
                            context.tr!.budget,
                          ),
                          errorText: state.errors['name'],
                          maxLength: 50,
                        ),
                        CustomTextFormField(
                          label: context.tr!.amount,
                          controller: _amountController,
                          hintText: context.tr!.budget_limit,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          errorText: state.errors['amount'],
                          paddingBottom: 0,
                        ),
                      ],
                    ),
                  ),
                  CustomDropdownMenu(
                    label: context.tr!.wallet,
                    options: state.wallets
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
                    selectedId: state.walletId,
                    errorText: state.errors['wallet'],
                    hasDivider: true,
                    margin: EdgeInsets.zero,
                    onSelect: (dynamic id) =>
                        context.read<BudgetCubit>().setData(walletId: id),
                  ),
                  CustomDateRangePicker(
                    label: context.tr!.budget_range,
                    startDate: state.startDate,
                    endDate: state.endDate,
                    errorText: state.errors['date'],
                    onPicked: (DateTimeRange range) => context
                        .read<BudgetCubit>()
                        .setData(startDate: range.start, endDate: range.end),
                  ),
                  ContainerForm(
                    child: CustomTextFormField(
                      label: context.tr!.note,
                      controller: _noteController,
                      hintText: context.tr!.budget_note_placeholder,
                      required: false,
                      errorText: state.errors['note'],
                      keyboardType: TextInputType.multiline,
                      maxLength: 200,
                      paddingBottom: 0,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
