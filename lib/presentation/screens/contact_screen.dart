import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class ContactScreen extends StatelessWidget {
  final bool isPickerMode;

  const ContactScreen({super.key, this.isPickerMode = false});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactCubit, ContactState>(
      listener: (context, state) {
        if (state is ContactError) {
          context.read<SharedCubit>().showDialog(
            type: AlertDialogType.error,
            title: state.type.title(
              context,
              context.tr!.contacts,
              context.tr!.contact,
            ),
            message: state.type.message(
              context,
              context.tr!.contacts,
              context.tr!.contact,
            ),
          );
        } else if (state is ContactSuccess) {
          context.read<SharedCubit>().showSnackBar(
            message: state.type.message(context, context.tr!.contact),
          );
        }
      },
      buildWhen: (previous, current) => [
        ContactLoaded,
        ContactLoading,
        ContactError,
      ].any((type) => current.runtimeType == type),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.tr!.contacts),
            actions: [
              if ((state is ContactLoaded) && state.contacts.isNotEmpty)
                IconButton(
                  onPressed: () => _goToForm(context: context),
                  icon: Icon(Icons.add_outlined),
                ),
            ],
          ),
          extendBodyBehindAppBar:
              (state is ContactLoaded && state.contacts.isNotEmpty)
              ? false
              : true,

          body: Builder(
            builder: (context) {
              if (state is ContactLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ContactLoaded && state.contacts.isNotEmpty) {
                return SafeArea(
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 3),
                    itemCount: state.contacts.length,
                    itemBuilder: (context, index) => ContactTile(
                      contact: state.contacts[index],
                      isPickerMode: isPickerMode,
                      onPressedEdit: (ContactModel contact) =>
                          _goToForm(context: context, contact: contact),
                      onPressedDelete: (ContactModel contact) =>
                          _deleteContact(context: context, contact: contact),
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        ListViewSeparatorDivider(height: 0),
                  ),
                );
              }
              return PlaceholderView(
                icon: AppIcons.contacts,
                title: context.tr!.contacts_empty_screen_title,
                subtitle: context.tr!.contacts_empty_screen_description,
                actions: [
                  PlaceholderViewAction(
                    title: context.tr!.create_resource(context.tr!.contact),
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

  void _goToForm({required BuildContext context, ContactModel? contact}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ContactCubit>(),
          child: ContactFormScreen(contact: contact),
        ),
      ),
    );
  }

  void _deleteContact({
    required BuildContext context,
    required ContactModel contact,
  }) {
    context.read<SharedCubit>().showDialog(
      type: AlertDialogType.confirm,
      title: context.tr!.delete_resource(context.tr!.contact),
      message: context.tr!.confirm_delete_resource_message(
        contact.name,
        context.tr!.contact,
      ),
      icon: AppIcons.contacts,
      callbackConfirm: () =>
          context.read<ContactCubit>().deleteContact(contact),
    );
  }
}
