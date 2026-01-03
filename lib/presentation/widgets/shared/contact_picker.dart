import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class ContactPicker extends StatefulWidget {
  final ContactModel? selectedContact;
  final Function(ContactModel category) onPicked;
  final EdgeInsetsGeometry? margin;
  final bool hasDivider;
  final String? errorText;

  const ContactPicker({
    super.key,
    required this.onPicked,
    this.hasDivider = false,
    this.errorText,
    this.selectedContact,
    this.margin,
  });

  @override
  State<ContactPicker> createState() => _ContactPickerState();
}

class _ContactPickerState extends State<ContactPicker> {
  ContactModel? contact;

  @override
  void initState() {
    super.initState();
    setState(() {
      contact = widget.selectedContact;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdownTile(
      onTap: () async {
        final ContactModel? newContact = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => ContactCubit()..loadContacts(),
              child: ContactScreen(isPickerMode: true),
            ),
          ),
        );
        if (newContact != null) {
          widget.onPicked(newContact);
          setState(() {
            contact = newContact;
          });
        }
      },
      label: contact?.name ?? context.tr!.contact,
      hasDivider: widget.hasDivider,
      margin: widget.margin,
      errorText: widget.errorText,
      icon: AppIcons.contacts,
      color: context.colors.primary,
    );
  }
}
