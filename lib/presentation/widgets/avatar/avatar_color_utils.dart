import 'package:flutter/material.dart';

class AvatarColorUtils {
  static final List<Color> _materialColors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
    Colors.deepOrange,
    Colors.cyan,
  ];

  /// Sinh màu ổn định dựa trên text (không random mỗi lần build)
  static Color backgroundFromText(String text) {
    if (text.isEmpty) return Colors.grey;
    final hash = text.codeUnits.fold(0, (a, b) => a + b);
    return _materialColors[hash % _materialColors.length];
  }

  /// Màu chữ tương phản theo Material
  static Color foreground(Color bg) {
    return ThemeData.estimateBrightnessForColor(bg) == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}
