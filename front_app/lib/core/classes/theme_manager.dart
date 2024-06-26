import '../../architect.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';

ThemeData defaultTheme = ThemeData(
  fontFamily: 'Okta',
  brightness: Brightness.light,
  primaryColor: AppColors.primaryBlue,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryBlue,
    secondary: AppColors.secondaryBlue,
    primaryContainer: AppColors.beigeColor,
    secondaryContainer: AppColors.peachColor,
    surface: AppColors.greyFair,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    backgroundColor: AppColors.white,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: AppColors.white,
  ),
  inputDecorationTheme:  const InputDecorationTheme(
    errorStyle: TextStyle(color: AppColors.red),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        color: AppColors.black,
        fontSize: 25,
        fontWeight: FontWeight.w600,
        fontFamily: 'Okta'),
    displayMedium: TextStyle(
        color: AppColors.grey, fontSize: 16, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(
        color: AppColors.black, fontSize: 18, fontWeight: FontWeight.w500),
    labelLarge: TextStyle(
        color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700),
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: Color.fromARGB(255, 11, 238, 250),
    elevation: 15,
    enableFeedback: true,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color.fromARGB(255, 213, 247, 249),
    elevation: 10,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.teal,
    selectedItemColor: Colors.white,
    elevation: 10,
    showSelectedLabels: true,
  ),
  primaryColorDark: AppColors.black,
  bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.teal),
  useMaterial3: true,
);

class AppTheme {
  ThemeData? light;
  ThemeData? dark;

  AppTheme([
    this.light,
    this.dark,
  ]) {
    light = light ?? defaultTheme;

    dark = dark ??
        defaultTheme.copyWith(
          scaffoldBackgroundColor: Colors.black,
          brightness: Brightness.dark,
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
            buttonColor: Colors.white,
          ),
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primaryBlue,
            secondary: AppColors.secondaryBlue,
            primaryContainer: AppColors.beigeColor,
            secondaryContainer: AppColors.peachColor,
            surface: AppColors.black,
          ),
          primaryColorDark: AppColors.white,
          textTheme: const TextTheme(
            displayLarge:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            displayMedium: TextStyle(
                color: AppColors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500),
            labelLarge: TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.space,
            selectedItemColor: AppColors.white,
            elevation: 10,
            showSelectedLabels: true,
          ),
        );
  }

  ThemeData get lightTheme => light!;
  ThemeData get darkTheme => dark!;

  AppTheme copyWith({
    ThemeData? light,
    ThemeData? dark,
  }) {
    return AppTheme(
      light ?? this.light,
      dark ?? this.dark,
    );
  }
}
