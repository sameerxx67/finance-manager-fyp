import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class ChangeThemeModeModalBottomSheet extends StatelessWidget {
  final ThemeMode themeMode;

  const ChangeThemeModeModalBottomSheet({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> themeModes = [
      {"id": ThemeMode.system, "name": context.tr!.follow_device_theme},
      {"id": ThemeMode.light, "name": context.tr!.light_theme},
      {"id": ThemeMode.dark, "name": context.tr!.dark_theme},
    ];

    return ModalBottomSheet(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.padding),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.padding,
          ),
          child: Text(
            context.tr!.change_theme_mode,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(height: 15),
        ListView.separated(
          primary: true,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) => CustomCheckbox(
            hiddenUnCheckIcon: true,
            hiddenLeading: true,
            title: themeModes[index]['name']!,
            checked: themeMode == themeModes[index]['id']!,
            onTap: () {
              final ThemeMode themeMode = themeModes[index]['id']!;
              Navigator.pop(context);
              context.read<SettingCubit>().setThemeMode(themeMode);
              context.read<SharedCubit>().updateThemeMode(themeMode);
            },
          ),
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 0.4,
              color: context.colors.divider.withValues(alpha: 0.5),
            ),
          ),
          itemCount: themeModes.length,
        ),
      ],
    );
  }
}
