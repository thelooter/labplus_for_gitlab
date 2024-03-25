import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Icon searchLeadingIcon() {
  return Platform.isAndroid
      ? const Icon(Icons.arrow_back)
      : const Icon(Icons.arrow_back_ios);
}

class AppSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Switch(value: value, onChanged: onChanged)
        : CupertinoSwitch(value: value, onChanged: onChanged);
  }
}
