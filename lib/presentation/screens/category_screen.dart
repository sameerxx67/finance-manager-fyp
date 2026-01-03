import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class CategoryScreen extends StatelessWidget {
  final bool isPickerMode;

  const CategoryScreen({super.key, this.isPickerMode = false});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state is CategoryError) {
          context.read<SharedCubit>().showDialog(
            type: AlertDialogType.error,
            title: state.type.title(
              context,
              context.tr!.categories,
              context.tr!.category,
            ),
            message: state.type.message(
              context,
              context.tr!.categories,
              context.tr!.category,
            ),
          );
        } else if (state is CategorySuccess) {
          context.read<SharedCubit>().showSnackBar(
            message: state.type.message(context, context.tr!.category),
          );
        }
      },
      buildWhen: (previous, current) => [
        CategoryLoaded,
        CategoryLoading,
        CategoryError,
      ].any((type) => current.runtimeType == type),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.tr!.manage_categories),
            bottom: HomeTabBar(
              selectedType: state is CategoryLoaded
                  ? state.selectedType
                  : TransactionType.income,
              onTabChanged: (TransactionType type) =>
                  context.read<CategoryCubit>().loadCategories(type: type),
            ),
            actions: [
              if ((state is CategoryLoaded) && state.categories.isNotEmpty)
                IconButton(
                  onPressed: () =>
                      _goToForm(context: context, type: state.selectedType),
                  icon: Icon(Icons.add_outlined),
                ),
            ],
          ),
          extendBodyBehindAppBar:
              (state is CategoryLoaded && state.categories.isNotEmpty)
              ? false
              : true,
          body: Builder(
            builder: (context) {
              if (state is CategoryLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is CategoryLoaded &&
                  state.categories.isNotEmpty) {
                return SafeArea(
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 3),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) => CategoryTile(
                      category: state.categories[index],
                      isPickerMode: isPickerMode,
                      onPressedEdit: (CategoryModel category) => _goToForm(
                        context: context,
                        category: category,
                        type: category.type,
                      ),
                      onPressedDelete: (CategoryModel category) =>
                          _deleteCategory(context: context, category: category),
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        ListViewSeparatorDivider(height: 0.6),
                  ),
                );
              }
              return PlaceholderView(
                icon: AppIcons.categories,
                title: context.tr!.categories_empty_screen_title,
                subtitle: context.tr!.categories_empty_screen_description,
                actions: [
                  PlaceholderViewAction(
                    title: context.tr!.create_resource(context.tr!.category),
                    icon: AppIcons.plus,
                    onTap: () => _goToForm(
                      context: context,
                      type: (state is CategoryLoaded)
                          ? state.selectedType
                          : TransactionType.income,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _goToForm({
    required BuildContext context,
    CategoryModel? category,
    required TransactionType type,
  }) async {
    final CategoryCubit cubit = context.read<CategoryCubit>();
    await cubit.formInit(
      color: category?.color,
      type: type,
      icon: category?.icon,
      categoryId: category?.categoryId,
      excludeId: category?.id,
    );
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: CategoryFormScreen(category: category, type: type),
        ),
      ),
    );
  }

  void _deleteCategory({
    required BuildContext context,
    required CategoryModel category,
  }) {
    context.read<SharedCubit>().showDialog(
      type: AlertDialogType.confirm,
      title: context.tr!.delete_resource(context.tr!.category),
      message: !category.hasSub
          ? context.tr!.confirm_message_delete_without_sub_category(
              category.name,
              context.tr!.category,
            )
          : context.tr!.confirm_message_delete_has_sub_category(
              category.name,
              context.tr!.category,
            ),
      icon: AppIcons.categories,
      callbackConfirm: () =>
          context.read<CategoryCubit>().deleteCategory(category),
    );
  }
}
