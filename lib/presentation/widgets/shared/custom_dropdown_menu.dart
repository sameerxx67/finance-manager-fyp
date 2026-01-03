import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class CustomDropdownMenu extends StatefulWidget {
  final String label;
  final String? errorText;
  final dynamic selectedId;
  final List<CustomDropdownMenuOption> options;
  final Function(dynamic id) onSelect;
  final EdgeInsetsGeometry? margin;
  final bool hasDivider;
  final String? defaultIcon;
  final Color? defaultIconColor;
  final bool hiddenLeading;
  final bool isMultiple;

  const CustomDropdownMenu({
    super.key,
    required this.label,
    required this.options,
    this.selectedId,
    required this.onSelect,
    this.margin,
    this.hasDivider = false,
    this.isMultiple = false,
    this.defaultIconColor,
    this.defaultIcon,
    this.hiddenLeading = false,
    this.errorText,
  });

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  CustomDropdownMenuOption? option;
  List<CustomDropdownMenuOption>? options;

  @override
  void initState() {
    super.initState();
    if (widget.selectedId != null) {
      if (widget.isMultiple) {
        _handleMultipleSelected();
      } else {
        _handleSingleSelected();
      }
    }
  }

  void _handleSingleSelected() {
    final selectedOption = widget.options
        .where((option) => option.id == widget.selectedId)
        .firstOrNull;

    if (selectedOption != null) {
      setState(() {
        option = selectedOption;
      });
    }
  }

  void _handleMultipleSelected() {
    List<CustomDropdownMenuOption> selectedOptions = [];
    for (final option in widget.options) {
      for (final id in widget.selectedId) {
        if (option.id == id) {
          selectedOptions.add(option);
        }
      }
    }

    setState(() {
      options = selectedOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContainerForm(
      paddingHorizontal: 0,
      paddingVertical: 0,
      margin:
          widget.margin ??
          EdgeInsets.only(bottom: AppDimensions.inputBottomMargin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDropdownTile(
            onTap: _openModalSheetOptions,
            label: option?.name ?? widget.label,
            hasDivider: widget.hasDivider,
            margin: EdgeInsets.zero,
            icon: option?.icon ?? widget.defaultIcon,
            color: option?.color ?? widget.defaultIconColor,
            errorText: widget.errorText,
          ),
          if (widget.isMultiple && options != null && options!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                height: 35,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  itemCount: options!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.only(
                      left: context.isRtl ? 8 : 0,
                      right: context.isRtl ? 0 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: (widget.defaultIconColor ?? context.colors.primary)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          options![index].name,
                          style: TextStyle(
                            color:
                                widget.defaultIconColor ??
                                context.colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          child: Icon(Icons.close, size: 18),
                          onTap: () {
                            setState(() {
                              options!.remove(options![index]);
                            });
                            widget.onSelect(
                              options!.map((option) => option.id).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openModalSheetOptions() {
    context.read<SharedCubit>().showModalBottomSheet(
      (_) => ViewItemsModalBottomSheet(
        onSelect: (dynamic newOption) {
          if (widget.isMultiple) {
            widget.onSelect(newOption.map((option) => option.id).toList());
            setState(() {
              options = newOption;
            });
          } else {
            if (widget.selectedId != newOption.id) {
              widget.onSelect(newOption.id);
              setState(() {
                option = newOption;
              });
            }
          }
          Navigator.pop(context);
        },
        hiddenLeading: widget.hiddenLeading,
        selectedId: widget.selectedId,
        options: widget.options,
        selectedOptions: options,
        isMultiple: widget.isMultiple,
      ),
    );
  }
}

class ViewItemsModalBottomSheet extends StatefulWidget {
  final dynamic selectedId;
  final List<CustomDropdownMenuOption> options;
  final List<CustomDropdownMenuOption>? selectedOptions;
  final bool hiddenLeading;
  final bool isMultiple;
  final Function(dynamic option) onSelect;

  const ViewItemsModalBottomSheet({
    super.key,
    required this.selectedId,
    required this.options,
    required this.hiddenLeading,
    this.selectedOptions,
    required this.isMultiple,
    required this.onSelect,
  });

  @override
  State<ViewItemsModalBottomSheet> createState() =>
      _ViewItemsModalBottomSheetState();
}

class _ViewItemsModalBottomSheetState extends State<ViewItemsModalBottomSheet> {
  dynamic selectedId;
  late List<CustomDropdownMenuOption> selectedOptions;

  @override
  void initState() {
    super.initState();
    selectedId = widget.isMultiple
        ? (widget.selectedId ?? [])
        : widget.selectedId;
    selectedOptions = widget.selectedOptions ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      padding: EdgeInsets.zero,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.50,
          child: ListView.separated(
            primary: true,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) => CustomCheckbox(
              hiddenUnCheckIcon: true,
              hiddenLeading: widget.hiddenLeading,
              title: widget.options[index].name,
              subtitle: widget.options[index].subtitle,
              trailingText: widget.options[index].trailingText,
              icon: widget.options[index].icon,
              color: widget.options[index].color,
              iconData: widget.options[index].iconData,
              checked: widget.isMultiple
                  ? selectedId.contains(widget.options[index].id)
                  : selectedId == widget.options[index].id,
              onTap: () {
                if (widget.isMultiple) {
                  final CustomDropdownMenuOption option = widget.options[index];
                  if (selectedId.contains(option.id)) {
                    setState(() {
                      selectedId.remove(option.id);
                      selectedOptions.remove(option);
                    });
                  } else {
                    setState(() {
                      selectedId.add(option.id);
                      selectedOptions.add(option);
                    });
                  }
                } else {
                  widget.onSelect(widget.options[index]);
                }
              },
            ),
            separatorBuilder: (BuildContext context, int index) =>
                ListViewSeparatorDivider(),
            itemCount: widget.options.length,
          ),
        ),
        if (widget.isMultiple)
          FormBottomNavigationBar(
            okButtonOnPressed: () {
              widget.onSelect(selectedOptions);
            },
          ),
      ],
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailingText;
  final String? icon;
  final Color? color;
  final IconData? iconData;
  final bool checked;
  final GestureTapCallback? onTap;
  final bool hiddenUnCheckIcon;
  final bool hiddenLeading;

  const CustomCheckbox({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.hiddenUnCheckIcon = false,
    this.onTap,
    this.checked = false,
    this.hiddenLeading = false,
    this.icon,
    this.color,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      leading: hiddenLeading
          ? null
          : Container(
              width: 32,
              height: 32,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: (color ?? context.colors.primary).withValues(
                  alpha: 0.15,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: icon != null
                  ? SvgIcon(
                      icon: icon!,
                      width: 25,
                      color: color ?? context.colors.primary,
                    )
                  : iconData != null
                  ? Icon(
                      iconData,
                      color: color ?? context.colors.primary,
                      size: 20,
                    )
                  : null,
            ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(color: context.colors.textSecondary),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                trailingText!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          if (!hiddenUnCheckIcon || checked)
            SvgIcon(
              icon: AppIcons.check,
              color: checked
                  ? context.colors.secondary
                  : context.colors.disabled,
              width: 20,
            ),
        ],
      ),
    );
  }
}
