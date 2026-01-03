import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class CategoryPicker extends StatefulWidget {
  final String label;
  final List<CategoryModel> categories;
  final int? selectedId;
  final String? errorText;
  final EdgeInsetsGeometry? margin;
  final bool hasDivider;

  final Function(CategoryModel category) onPicked;

  const CategoryPicker({
    super.key,
    required this.label,
    required this.categories,
    required this.onPicked,
    this.selectedId,
    this.errorText,
    this.margin,
    this.hasDivider = false,
  });

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  CategoryModel? category;

  @override
  void initState() {
    super.initState();
    if (widget.selectedId != null) {
      _handleSelectedCategory();
    }
  }

  @override
  void didUpdateWidget(covariant CategoryPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedId != widget.selectedId) {
      _handleSelectedCategory();
    }
  }

  void _handleSelectedCategory() {
    CategoryModel? selectedOption;

    for (final option in widget.categories) {
      if (option.id == widget.selectedId) {
        selectedOption = option;
        break;
      }

      if (option.hasSub) {
        final sub = option.categories
            ?.where((sub) => sub.id == widget.selectedId)
            .firstOrNull;
        if (sub != null) {
          selectedOption = sub;
          break;
        }
      }
    }

    setState(() {
      category = selectedOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdownTile(
      onTap: _openPicker,
      label: category?.name ?? widget.label,
      hasDivider: widget.hasDivider,
      margin: widget.margin,
      icon: category?.icon ?? AppIcons.categories,
      color: category?.nativeColor,
      errorText: widget.errorText,
    );
  }

  void _openPicker() {
    context.read<SharedCubit>().showModalBottomSheet(
      (_) => CategoryPickerModalBottomSheet(
        categories: widget.categories,
        onPicked: (CategoryModel category) => _onPicked(category),
      ),
    );
  }

  void _onPicked(CategoryModel category) {
    setState(() {
      this.category = category;
    });
    widget.onPicked(category);
    Navigator.pop(context);
  }
}
