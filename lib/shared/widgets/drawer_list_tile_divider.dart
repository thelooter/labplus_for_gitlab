import 'package:flutter/material.dart';

class DrawerListTileDivider extends StatelessWidget {
  const DrawerListTileDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
        color: Colors.grey, indent: 15, endIndent: 50, thickness: 0.2);
  }
}
