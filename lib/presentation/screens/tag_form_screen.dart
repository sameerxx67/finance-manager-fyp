import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class TagFormScreen extends StatefulWidget {
  final TagModel? tag;

  const TagFormScreen({super.key, this.tag});

  @override
  State<TagFormScreen> createState() => _TagFormScreenState();
}

class _TagFormScreenState extends State<TagFormScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.tag != null) {
      _nameController.text = widget.tag!.name;
    }
    context.read<TagCubit>().formInit(color: widget.tag?.color);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagCubit, TagState>(
      buildWhen: (previous, current) => current.runtimeType == TagFormInitial,
      builder: (context, state) {
        if (state is TagFormInitial) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.tag != null
                    ? context.tr!.edit_resource(context.tr!.tag)
                    : context.tr!.create_resource(context.tr!.tag),
              ),
            ),
            bottomNavigationBar: FormBottomNavigationBar(
              okButtonOnPressed: () async {
                if (await context.read<TagCubit>().submit(
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
                  widget.tag,
                  _nameController.text,
                )) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                }
              },
              okButtonLoading: state.processing,
              okButtonText: widget.tag == null
                  ? context.tr!.create
                  : context.tr!.update,
            ),
            body: Column(
              children: [
                ContainerForm(
                  child: CustomTextFormField(
                    label: context.tr!.name,
                    controller: _nameController,
                    hintText: context.tr!.enter_resource_name(context.tr!.tag),
                    errorText: state.errors['name'],
                    maxLength: 30,
                    suffixIcon: CustomColorPicker(
                      resource: context.tr!.tag,
                      color: state.color,
                      onColorPicked: context.read<TagCubit>().setColor,
                    ),
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
