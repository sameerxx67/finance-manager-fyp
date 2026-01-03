import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class CategorySummaryTile extends StatelessWidget {
  final CategorySummaryModel category;

  const CategorySummaryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.surface,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: category.nativeColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: SvgIcon(
              icon: category.icon,
              color: category.nativeColor,
              width: 18,
            ),
          ),
        ),
        title: Text(
          category.name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        trailing: Text(category.total.format()),
      ),
    );
  }
}
