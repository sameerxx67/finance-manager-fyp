import 'package:flutter/widgets.dart';
import 'package:zenthory/zenthory.dart';

extension TranslateExtension on BuildContext {
  AppLocalizations? get tr => AppLocalizations.of(this);
}
