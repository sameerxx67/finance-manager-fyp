import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class CustomColorPicker extends StatelessWidget {
  final String color;
  final String resource;
  final Function(String color) onColorPicked;

  const CustomColorPicker({
    super.key,
    required this.resource,
    required this.onColorPicked,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openColorPicker(context),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(int.parse("0XFF$color")),
          ),
        ),
      ),
    );
  }

  void _openColorPicker(BuildContext context) {
    context.read<SharedCubit>().showModalBottomSheet(
      (_) => ColorPickerModalBottomSheet(
        selectedColor: color,
        resource: resource,
        onColorPicked: (String newColor) => _onColorPicked(context, newColor),
      ),
    );
  }

  void _onColorPicked(BuildContext context, String newColor) {
    onColorPicked(newColor);
    Navigator.pop(context);
  }
}
