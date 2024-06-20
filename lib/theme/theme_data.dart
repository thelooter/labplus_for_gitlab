import 'package:flutter/material.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';

class ThemeConfig with ChangeNotifier {
  static ThemeData createTheme({
    required Brightness brightness,
    required Color background,
    required Color secondary,
    required Color chipSelectedColor,
    Color? appBarColor,
    Color? iconColor,
  }) {
    return ThemeData(
      brightness: brightness,
      appBarTheme: AppBarTheme(centerTitle: true, color: appBarColor),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(backgroundColor: background),
/*      colorScheme: ColorScheme.fromSwatch(
              brightness: brightness,
              backgroundColor: background)
          .copyWith(secondary: secondary, primary: secondary),*/
      colorScheme:
          ColorScheme.fromSeed(seedColor: Colors.lightBlue, brightness: brightness),
      dividerTheme: const DividerThemeData(
        space: 0,
      ),
      iconTheme: IconThemeData(color: iconColor ?? secondary),
      indicatorColor: Colors.white,
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(foregroundColor: Colors.white),
    );
  }

  static ThemeData get lightTheme => createTheme(
        brightness: Brightness.light,
        background: ColorConstants.lightScaffoldBackgroundColor,
        secondary: Colors.lightBlue,
        chipSelectedColor: Colors.lightGreen,
        appBarColor: Colors.lightBlue,
        iconColor: Colors.black,
      );

  static ThemeData get darkTheme => createTheme(
      brightness: Brightness.dark,
      background: ColorConstants.darkScaffoldBackgroundColor,
      secondary: Colors.lightBlue,
      chipSelectedColor: Colors.green,
      appBarColor: Colors.lightBlue,
      iconColor: Colors.white);

  static switchTheme() {}
}
