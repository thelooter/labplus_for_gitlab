import 'package:flutter/material.dart';
import 'package:labplus_for_gitlab/theme/theme.dart';

class ColorLabel extends StatelessWidget {
  final Color color;
  final String text;
  final double? fontSize;
  final EdgeInsets? padding;

  const ColorLabel({
    super.key,
    required this.color,
    required this.text,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: fontSize, color: ThemeUtils.computeIluminance(color)),
      ),
    );
  }
}
