import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class BudgetTile extends StatelessWidget {
  final BudgetModel budget;
  final Function(BudgetModel budget) onPressedEdit;
  final Function(BudgetModel budget) onPressedDelete;

  const BudgetTile({
    super.key,
    required this.budget,
    required this.onPressedEdit,
    required this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<SharedCubit>().showModalBottomSheet(
        (context) => ActionsModalBottomSheet(
          actions: [
            ActionModalBottomSheet(
              icon: AppIcons.edit,
              title: context.tr!.edit_resource(context.tr!.budget),
              iconColor: context.colors.success,
              onTap: () => onPressedEdit(budget),
            ),
            ActionModalBottomSheet(
              icon: AppIcons.delete,
              title: context.tr!.delete_resource(context.tr!.budget),
              iconColor: context.colors.error,
              onTap: () => onPressedDelete(budget),
            ),
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: context.colors.surface,
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (budget.category != null)
                  Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: budget.category?.nativeColor.withValues(
                        alpha: 0.15,
                      ),
                    ),
                    child: SvgIcon(
                      icon: budget.category!.icon,
                      color: budget.category?.nativeColor,
                    ),
                  ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      context.read<SharedCubit>().formatRange(
                        budget.startDate,
                        budget.endDate,
                      ),
                      style: TextStyle(color: context.colors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            LinearProgressIndicator(
              value: budget.progressValue,
              backgroundColor: context.colors.textPlaceholder.withValues(
                alpha: 0.2,
              ),
              color: budget.progressColor,
              minHeight: 8,
              borderRadius: BorderRadius.circular(5),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budget.spentMoney.format(),
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                Text(
                  context.tr!.spent_of,
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                Text(
                  budget.amountMoney.format(),
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
