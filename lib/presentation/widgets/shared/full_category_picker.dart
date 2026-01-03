import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class FullCategoryPicker extends StatefulWidget {
  final String label;
  final CategoryModel? selectedCategory;
  final Function(CategoryModel category) onPicked;
  final EdgeInsetsGeometry? margin;
  final bool hasDivider;

  const FullCategoryPicker({
    super.key,
    required this.label,
    required this.onPicked,
    this.hasDivider = false,
    this.selectedCategory,
    this.margin,
  });

  @override
  State<FullCategoryPicker> createState() => _FullCategoryPickerState();
}

class _FullCategoryPickerState extends State<FullCategoryPicker> {
  CategoryModel? category;

  @override
  void initState() {
    super.initState();
    setState(() {
      category = widget.selectedCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdownTile(
      onTap: () async {
        final CategoryModel? newCategory = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) =>
                  CategoryCubit()..loadCategories(type: TransactionType.income),
              child: CategoryScreen(isPickerMode: true),
            ),
          ),
        );
        if (newCategory != null) {
          widget.onPicked(newCategory);
          setState(() {
            category = newCategory;
          });
        }
      },
      label: category?.name ?? widget.label,
      hasDivider: widget.hasDivider,
      margin: widget.margin,
      icon: category?.icon ?? AppIcons.categories,
      color: category?.nativeColor,
    );
  }
}
