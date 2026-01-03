import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class ColorPickerModalBottomSheet extends StatelessWidget {
  final String resource;
  final String selectedColor;
  final Function(String color) onColorPicked;

  const ColorPickerModalBottomSheet({
    super.key,
    required this.selectedColor,
    required this.resource,
    required this.onColorPicked,
  });

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      heightFactor: 0.6,
      padding: const EdgeInsets.only(
        top: 30,
        left: AppDimensions.padding,
        right: AppDimensions.padding,
      ),
      children: [
        Text(
          context.tr!.color_picker,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          context.tr!.color_picker_description(resource),
          style: TextStyle(color: context.colors.textSecondary, fontSize: 16),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.43,
          child: GridView.count(
            primary: true,
            crossAxisCount: 6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
            children: List.generate(AppStrings.knownColors.length, (index) {
              final color = AppStrings.knownColors[index];
              return _buildColor(
                context: context,
                color: color,
                isSelected: selectedColor == color,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildColor({
    required BuildContext context,
    required String color,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onColorPicked(color),
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: context.colors.textSecondary, width: 1.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.colors.textSecondary.withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color(int.parse("0XFF$color")),
            borderRadius: BorderRadius.circular(isSelected ? 7 : 10),
          ),
        ),
      ),
    );
  }
}
