import 'package:flutter/material.dart';

extension IsRtlExtension on BuildContext {
  bool get isRtl => Localizations.localeOf(this).languageCode == "ar";
}
