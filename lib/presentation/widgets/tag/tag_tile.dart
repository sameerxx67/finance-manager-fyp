import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class TagTile extends StatelessWidget {
  final TagModel tag;
  final Function(TagModel tag) onPressedEdit;
  final Function(TagModel tag) onPressedDelete;

  const TagTile({
    super.key,
    required this.tag,
    required this.onPressedEdit,
    required this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      tileColor: context.colors.surface,
      leading: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: tag.nativeColor,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      title: Text(tag.name, style: TextStyle(fontWeight: FontWeight.bold)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onPressedEdit(tag),
            child: SvgIcon(
              icon: AppIcons.edit,
              width: 15,
              color: context.colors.success.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () => onPressedDelete(tag),
            child: SvgIcon(
              icon: AppIcons.delete,
              width: 15,
              color: context.colors.error.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
