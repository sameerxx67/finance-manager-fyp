import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class IconPickerModalBottomSheet extends StatelessWidget {
  final String resource;
  final String selectedIcon;
  final Function(String icon) onPicked;

  const IconPickerModalBottomSheet({
    super.key,
    required this.selectedIcon,
    required this.resource,
    required this.onPicked,
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
          context.tr!.icon_picker,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          context.tr!.icon_picker_description(resource),
          style: TextStyle(color: context.colors.textSecondary, fontSize: 16),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.43,
          child: GridView.count(
            primary: true,
            crossAxisCount: 7,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: List.generate(AppStrings.icons.length, (index) {
              final String fullPath =
                  "${AppStrings.iconPath}${AppStrings.icons[index]}.svg";
              return GestureDetector(
                onTap: () => onPicked(fullPath),
                child: SvgIcon(
                  icon: fullPath,
                  color: fullPath == selectedIcon
                      ? context.colors.secondary
                      : context.colors.textPrimary,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
