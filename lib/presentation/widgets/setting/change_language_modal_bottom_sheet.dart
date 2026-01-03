import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class ChangeLanguageModalBottomSheet extends StatelessWidget {
  final Locale locale;

  const ChangeLanguageModalBottomSheet({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.padding),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.padding,
          ),
          child: Text(
            context.tr!.change_language,
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
            title: AppStrings.languages[index]['name']!,
            checked: locale.languageCode == AppStrings.languages[index]['id']!,
            onTap: () {
              final Locale locale = Locale(AppStrings.languages[index]['id']!);
              Navigator.pop(context);
              context.read<SettingCubit>().setLocale(locale);
              context.read<SharedCubit>().updateLocale(
                Locale(AppStrings.languages[index]['id']!),
              );
            },
          ),
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 0.4,
              color: context.colors.divider.withValues(alpha: 0.5),
            ),
          ),
          itemCount: AppStrings.languages.length,
        ),
      ],
    );
  }
}
