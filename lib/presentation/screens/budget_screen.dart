import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BudgetCubit, BudgetState>(
      listener: (context, state) {
        if (state is BudgetError) {
          context.read<SharedCubit>().showDialog(
            type: AlertDialogType.error,
            title: state.type.title(
              context,
              context.tr!.budgets,
              context.tr!.budget,
            ),
            message: state.type.message(
              context,
              context.tr!.budgets,
              context.tr!.budget,
            ),
          );
        } else if (state is BudgetSuccess) {
          context.read<SharedCubit>().showSnackBar(
            message: state.type.message(context, context.tr!.budget),
          );
        }
      },
      buildWhen: (previous, current) => [
        BudgetLoaded,
        BudgetLoading,
        BudgetError,
      ].any((type) => current.runtimeType == type),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.tr!.manage_budgets),
            actions: [
              if ((state is BudgetLoaded) && state.budgets.isNotEmpty)
                IconButton(
                  onPressed: () => _goToForm(context: context),
                  icon: Icon(Icons.add_outlined),
                ),
            ],
          ),
          extendBodyBehindAppBar:
              (state is BudgetLoaded && state.budgets.isNotEmpty)
              ? false
              : true,
          body: Builder(
            builder: (context) {
              if (state is BudgetLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is BudgetLoaded && state.budgets.isNotEmpty) {
                return SafeArea(
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppDimensions.padding),
                    itemCount: state.budgets.length,
                    itemBuilder: (context, index) => BudgetTile(
                      budget: state.budgets[index],
                      onPressedEdit: (BudgetModel budget) =>
                          _goToForm(context: context, budget: budget),
                      onPressedDelete: (BudgetModel budget) =>
                          _deleteBudget(context: context, budget: budget),
                    ),
                  ),
                );
              }
              return PlaceholderView(
                icon: AppIcons.budgets,
                title: context.tr!.budgets_empty_screen_title,
                subtitle: context.tr!.budgets_empty_screen_description,
                actions: [
                  PlaceholderViewAction(
                    title: context.tr!.create_resource(context.tr!.budget),
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

  void _goToForm({required BuildContext context, BudgetModel? budget}) async {
    final BudgetCubit budgetCubit = context.read<BudgetCubit>();
    await budgetCubit.formInit(
      startDate: budget?.startDate,
      endDate: budget?.endDate,
      categoryId: budget?.categoryId,
      walletId: budget?.walletId,
    );

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: budgetCubit,
          child: BudgetFormScreen(budget: budget),
        ),
      ),
    );
  }

  void _deleteBudget({
    required BuildContext context,
    required BudgetModel budget,
  }) {
    context.read<SharedCubit>().showDialog(
      type: AlertDialogType.confirm,
      title: context.tr!.delete_resource(context.tr!.budget),
      message: context.tr!.confirm_delete_resource_message(
        budget.name,
        context.tr!.budget,
      ),
      icon: AppIcons.budgets,
      callbackConfirm: () =>
          context.read<BudgetCubit>().deleteBudget(budget.id),
    );
  }
}
