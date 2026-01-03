import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class CategoryFormScreen extends StatefulWidget {
  final CategoryModel? category;
  final TransactionType type;

  const CategoryFormScreen({super.key, this.category, required this.type});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (previous, current) =>
          current.runtimeType == CategoryFormInitial,
      builder: (context, state) {
        if (state is CategoryFormInitial) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.category != null
                    ? context.tr!.edit_resource(context.tr!.category)
                    : context.tr!.create_resource(context.tr!.category),
              ),
            ),
            bottomNavigationBar: FormBottomNavigationBar(
              okButtonOnPressed: () async {
                if (await context.read<CategoryCubit>().submit(
                  {
                    "name_is_required": context.tr!.attribute_is_required(
                      context.tr!.name,
                    ),
                    "name_should_be_between_min_to_max_characters": context.tr!
                        .attribute_should_be_between_min_to_max_characters(
                          context.tr!.name,
                          50,
                          2,
                        ),
                    "this_name_is_already_used": context.tr!
                        .this_attribute_is_already_used(context.tr!.name),
                    "main_category_is_required": context.tr!
                        .attribute_is_required(context.tr!.main_category),
                  },
                  widget.category,
                  _nameController.text,
                )) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                }
              },
              okButtonLoading: state.processing,
              okButtonText: widget.category == null
                  ? context.tr!.create
                  : context.tr!.update,
            ),
            body: Column(
              children: [
                if (widget.category == null)
                  CustomDropdownMenu(
                    label: context.tr!.type,
                    hasDivider: true,
                    margin: EdgeInsets.zero,
                    options: TransactionType.values
                        .map(
                          (TransactionType type) => CustomDropdownMenuOption(
                            id: type,
                            name: type.toTrans(context),
                            icon: type.icon,
                            color: type.color,
                          ),
                        )
                        .toList(),
                    defaultIcon: AppIcons.transaction,
                    selectedId: state.type,
                    onSelect: (id) => context.read<CategoryCubit>().setData(
                      type: id,
                      errors: {},
                      loadCategories: true,
                      excludeId: widget.category?.id,
                    ),
                  ),
                if (widget.category == null ||
                    widget.category != null && !widget.category!.builtIn)
                  CategoryPicker(
                    label: context.tr!.main_category,
                    categories: state.rootCategories,
                    errorText: state.errors['category_id'],
                    selectedId: state.categoryId,
                    onPicked: (CategoryModel category) => context
                        .read<CategoryCubit>()
                        .setData(categoryId: category.id),
                  ),
                ContainerForm(
                  paddingHorizontal: 10,
                  child: CustomTextFormField(
                    label: context.tr!.name,
                    controller: _nameController,
                    hintText: context.tr!.enter_resource_name(
                      context.tr!.category,
                    ),
                    maxLength: 50,
                    errorText: state.errors['name'],
                    suffixIcon: CustomColorPicker(
                      resource: context.tr!.category,
                      color: state.color,
                      onColorPicked: (String color) =>
                          context.read<CategoryCubit>().setData(color: color),
                    ),
                    paddingBottom: 0,
                    prefixIcon: CustomIconPicker(
                      icon: state.icon,
                      color: state.color,
                      resource: context.tr!.category,
                      onIconPicked: (String icon) =>
                          context.read<CategoryCubit>().setData(icon: icon),
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
