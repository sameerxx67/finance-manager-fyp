import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class CustomIconPicker extends StatelessWidget {
  final String color;
  final String icon;
  final String resource;
  final Function(String icon) onIconPicked;

  const CustomIconPicker({
    super.key,
    required this.icon,
    required this.resource,
    required this.onIconPicked,
    this.color = AppStrings.defaultColorPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => _openIconPicker(context),
        child: Container(
          width: 30,
          height: 30,
          padding: const EdgeInsets.all(7.0),
          decoration: BoxDecoration(
            color: Color(int.parse("0XFF$color")),
            borderRadius: BorderRadius.circular(15),
          ),
          child: SvgIcon(icon: icon, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _openIconPicker(BuildContext context) async {
    context.read<SharedCubit>().showModalBottomSheet(
      (_) => IconPickerModalBottomSheet(
        selectedIcon: icon,
        resource: resource,
        onPicked: (String newIcon) {
          onIconPicked(newIcon);
          Navigator.pop(context);
        },
      ),
    );
  }
}
