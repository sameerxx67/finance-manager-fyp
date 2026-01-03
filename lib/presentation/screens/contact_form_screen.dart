import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class ContactFormScreen extends StatefulWidget {
  final ContactModel? contact;

  const ContactFormScreen({super.key, this.contact});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ContactCubit>().formInit();

    _nameController.text = widget.contact?.name ?? '';
    _noteController.text = widget.contact?.note ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      buildWhen: (previous, current) =>
          current.runtimeType == ContactFormInitial,
      builder: (context, state) {
        if (state is ContactFormInitial) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.contact != null
                    ? context.tr!.edit_resource(context.tr!.contact)
                    : context.tr!.create_resource(context.tr!.contact),
              ),
            ),
            bottomNavigationBar: FormBottomNavigationBar(
              okButtonOnPressed: () async {
                if (await context.read<ContactCubit>().submit(
                  {
                    "name_is_required": context.tr!.attribute_is_required(
                      context.tr!.name,
                    ),
                    "name_should_be_between_min_to_max_characters": context.tr!
                        .attribute_should_be_between_min_to_max_characters(
                          context.tr!.name,
                          30,
                          2,
                        ),
                    "this_name_is_already_used": context.tr!
                        .this_attribute_is_already_used(context.tr!.name),
                  },
                  widget.contact,
                  _nameController.text,
                  _noteController.text,
                )) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                }
              },
              okButtonLoading: state.processing,
              okButtonText: widget.contact == null
                  ? context.tr!.create
                  : context.tr!.update,
            ),
            body: Column(
              children: [
                ContainerForm(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        label: context.tr!.name,
                        controller: _nameController,
                        hintText: context.tr!.enter_resource_name(
                          context.tr!.contact,
                        ),
                        errorText: state.errors['name'],
                        maxLength: 30,
                      ),
                    ],
                  ),
                ),
                ContainerForm(
                  child: CustomTextFormField(
                    label: context.tr!.note,
                    controller: _noteController,
                    hintText: context.tr!.contact_note_hint_text,
                    errorText: state.errors['note'],
                    maxLength: 30,
                    required: false,
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
