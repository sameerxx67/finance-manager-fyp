import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class TagScreen extends StatelessWidget {
  const TagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TagCubit, TagState>(
      listener: (context, state) {
        if (state is TagError) {
          context.read<SharedCubit>().showDialog(
            type: AlertDialogType.error,
            title: state.type.title(context, context.tr!.tags, context.tr!.tag),
            message: state.type.message(
              context,
              context.tr!.tags,
              context.tr!.tag,
            ),
          );
        } else if (state is TagSuccess) {
          context.read<SharedCubit>().showSnackBar(
            message: state.type.message(context, context.tr!.tag),
          );
        }
      },
      buildWhen: (previous, current) => [
        TagLoaded,
        TagLoading,
        TagError,
      ].any((type) => current.runtimeType == type),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.tr!.manage_tags),
            actions: [
              if ((state is TagLoaded) && state.tags.isNotEmpty)
                IconButton(
                  onPressed: () => _goToForm(context: context),
                  icon: Icon(Icons.add_outlined),
                ),
            ],
          ),
          extendBodyBehindAppBar: (state is TagLoaded && state.tags.isNotEmpty)
              ? false
              : true,

          body: Builder(
            builder: (context) {
              if (state is TagLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is TagLoaded && state.tags.isNotEmpty) {
                return SafeArea(
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 3),
                    itemCount: state.tags.length,
                    itemBuilder: (context, index) => TagTile(
                      tag: state.tags[index],
                      onPressedEdit: (TagModel tag) =>
                          _goToForm(context: context, tag: tag),
                      onPressedDelete: (TagModel tag) =>
                          _deleteTag(context: context, tag: tag),
                    ),

                    separatorBuilder: (BuildContext context, int index) =>
                        ListViewSeparatorDivider(height: 0.6),
                  ),
                );
              }
              return PlaceholderView(
                icon: AppIcons.tags,
                title: context.tr!.tags_empty_screen_title,
                subtitle: context.tr!.tags_empty_screen_description,
                actions: [
                  PlaceholderViewAction(
                    title: context.tr!.create_resource(context.tr!.tag),
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

  void _goToForm({required BuildContext context, TagModel? tag}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TagCubit>(),
          child: TagFormScreen(tag: tag),
        ),
      ),
    );
  }

  void _deleteTag({required BuildContext context, required TagModel tag}) {
    context.read<SharedCubit>().showDialog(
      type: AlertDialogType.confirm,
      title: context.tr!.delete_resource(context.tr!.tag),
      message: context.tr!.confirm_delete_resource_message(
        tag.name,
        context.tr!.tag,
      ),
      icon: AppIcons.tags,
      callbackConfirm: () => context.read<TagCubit>().deleteTag(tag.id),
    );
  }
}
