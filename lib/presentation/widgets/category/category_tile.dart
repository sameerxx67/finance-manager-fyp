import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class CategoryTile extends StatefulWidget {
  final CategoryModel category;
  final bool initiallyExpanded;
  final bool isPickerMode;
  final Function(CategoryModel category) onPressedEdit;
  final Function(CategoryModel category) onPressedDelete;

  const CategoryTile({
    super.key,
    required this.category,
    required this.onPressedEdit,
    required this.onPressedDelete,
    this.initiallyExpanded = false,
    this.isPickerMode = false,
  });

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  bool _isExpanded = false;

  _pickedCategory() {
    Navigator.pop(context, widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: context.colors.surface,
      child: GestureDetector(
        onLongPress: !widget.isPickerMode && widget.category.builtIn
            ? () => widget.onPressedEdit(widget.category)
            : null,
        onTap: widget.isPickerMode ? _pickedCategory : null,
        child: ExpansionTile(
          initiallyExpanded:
              (widget.initiallyExpanded) &&
              (widget.category.categories != null &&
                  widget.category.categories!.isNotEmpty),
          onExpansionChanged: (bool isExpanded) {
            setState(() {
              _isExpanded = isExpanded;
            });
          },
          childrenPadding: const EdgeInsets.only(top: 10),
          enabled:
              widget.category.categories != null &&
              widget.category.categories!.isNotEmpty,
          dense: true,
          leading: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: widget.category.nativeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SvgIcon(
                icon: widget.category.icon,
                color: widget.category.nativeColor,
                width: 18,
              ),
            ),
          ),
          title: Text(
            widget.category.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          subtitle: widget.category.description != null
              ? Text(
                  widget.category.description!,
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 11,
                  ),
                )
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!widget.category.builtIn && !widget.isPickerMode)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => widget.onPressedEdit(widget.category),
                      child: SvgIcon(
                        icon: AppIcons.edit,
                        width: 15,
                        color: context.colors.success.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(width: 10),

                    GestureDetector(
                      onTap: () => widget.onPressedDelete(widget.category),
                      child: SvgIcon(
                        icon: AppIcons.delete,
                        width: 15,
                        color: context.colors.error.withValues(alpha: 0.6),
                      ),
                    ),
                    if (widget.category.categories != null &&
                        widget.category.categories!.isNotEmpty)
                      SizedBox(width: 10),
                  ],
                ),

              if (widget.category.categories != null &&
                  widget.category.categories!.isNotEmpty)
                Row(
                  children: [
                    if (widget.isPickerMode)
                      IconButton(
                        onPressed: _pickedCategory,
                        icon: Icon(
                          Icons.check,
                          color: context.colors.textPlaceholder,
                          size: 18,
                        ),
                      ),
                    SvgIcon(
                      icon: _isExpanded ? AppIcons.angleUp : AppIcons.angleDown,
                      width: 15,
                      color: context.colors.textPrimary,
                    ),
                  ],
                ),
            ],
          ),
          children: widget.category.categories != null
              ? widget.category.categories!
                    .map(
                      (CategoryModel subCategory) => CategoryTile(
                        category: subCategory,
                        isPickerMode: widget.isPickerMode,
                        onPressedEdit: widget.onPressedEdit,
                        onPressedDelete: widget.onPressedDelete,
                      ),
                    )
                    .toList()
              : [],
        ),
      ),
    );
  }
}
