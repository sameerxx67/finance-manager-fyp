import 'dart:math';

class ColorUtils {
  static String generateRandomColorHex() {
    final random = Random();
    final colorValue = random.nextInt(0xFFFFFF);
    return colorValue.toRadixString(16).padLeft(6, '0').toUpperCase();
  }
}
