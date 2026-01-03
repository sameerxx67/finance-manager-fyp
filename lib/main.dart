import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:zenthory/zenthory.dart';

import 'data/seeders/dame_data_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocAppObserver();

  final SharedPreferencesService preferencesService =
      SharedPreferencesService();
  final Map<String, dynamic> settings = await preferencesService.getSettings();

  if (settings['enable_screenshot']) {
    NoScreenshot.instance.screenshotOn();
  } else {
    NoScreenshot.instance.screenshotOff();
  }

  Money.setDefaultCurrency = settings['currency'];

  if (AppStrings.isDemo && !settings['is_demo_data_seeded']) {
    await DameDataSeeder().seed();
    await preferencesService.setDemoDataSeededAt();
  }

  runApp(
    ZenthoryApp(
      locale: settings['language'],
      themeMode: settings['theme_mode'],
    ),
  );
}
