import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class CategoryPickerTile extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final Function(CategoryModel category) onPicked;

  const CategoryPickerTile({
    super.key,
    required this.category,
    required this.onPicked,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () => onPicked(category),
        child: ExpansionTile(
          showTrailingIcon:
              category.categories != null && category.categories!.isNotEmpty,
          initiallyExpanded:
              category.categories != null && category.categories!.isNotEmpty,
          childrenPadding: EdgeInsets.zero,
          enabled: false,

          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
          trailing: SizedBox.shrink(),
          children: category.categories != null
              ? category.categories!
                    .map(
                      (CategoryModel subCategory) => CategoryPickerTile(
                        category: subCategory,
                        onPicked: onPicked,
                      ),
                    )
                    .toList()
              : [],
        ),
      ),
    );
  }
}
