import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class ContactTile extends StatelessWidget {
  final ContactModel contact;
  final bool isPickerMode;

  final Function(ContactModel contact) onPressedEdit;
  final Function(ContactModel contact) onPressedDelete;

  const ContactTile({
    super.key,
    required this.contact,
    required this.onPressedEdit,
    required this.onPressedDelete,
    this.isPickerMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: context.colors.surface,
      onTap: isPickerMode ? () => _pickedContact(context) : null,
      dense: true,
      leading: CircleAvatar(
        backgroundColor: contact.nativeColor,
        radius: 16,
        child: Text(
          contact.name[0].toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            // fontSize: 15,
          ),
        ),
      ),
      title: Text(contact.name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: contact.note == null || contact.note!.isEmpty
          ? null
          : Text(
              contact.note!,
              style: TextStyle(color: context.colors.textSecondary),
            ),
      trailing: isPickerMode
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => onPressedEdit(contact),
                  child: SvgIcon(
                    icon: AppIcons.edit,
                    width: 15,
                    color: context.colors.success.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => onPressedDelete(contact),
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

  _pickedContact(BuildContext context) {
    Navigator.pop(context, contact);
  }
}
