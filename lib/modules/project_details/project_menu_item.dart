import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectMenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() onPressed;

  const ProjectMenuItemWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Get.theme.cardColor,
      foregroundColor: Get.theme.iconTheme.color,
      padding: const EdgeInsets.symmetric(vertical: 10),
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(5)),
      // ),
    );

    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          const SizedBox(height: 5),
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              )),
        ],
      ),
    );
  }
}
