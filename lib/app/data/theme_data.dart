import 'package:flutter/material.dart';

/// 创建时间：2022/11/3
/// @Description 自定义主题
final ThemeData defaultTheme = buildDefaultTheme();

class Config {
  /// 主题颜色
  static const int _primaryColorValue = 0xFFF5F6F8;
  static const Color primaryColor = Color(_primaryColorValue);
  static const MaterialColor primarySwatchColor = MaterialColor(
    _primaryColorValue,
    <int, Color>{
      50: Color(0xFFEAEAEA),
      100: Color(0xFFA9C2AC),
      200: Color(_primaryColorValue),
      300: Color(0xFF334B78),
      400: Color(0xFF2C646E),
      500: Color(0xFF1A4B57),
      600: Color(0xFF0B3946),
      700: Color(0xFF022D3B),
      800: Color(0xFF092C50),
      900: Color(0xFF2C2647),
    },
  );
}

ThemeData buildDefaultTheme() {
  return ThemeData(
    // useMaterial3: true,
    primarySwatch: Config.primarySwatchColor,
    // primaryColor: Config.primaryColor,
    // buttonTheme: ButtonThemeData(
    //   //按钮主题，最窄150，按钮文本主题复用ButtonTextTheme，圆角边框10，水平垂直留空
    //   minWidth: 150,
    //   textTheme: ButtonTextTheme.primary,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    //   padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
    // ),
    // inputDecorationTheme: InputDecorationTheme(
    //   //文本输入框主题，圆角，内边距
    //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    //   contentPadding: const EdgeInsets.all(16.0),
    // ),
  );
}

ThemeData appDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.red,
  scaffoldBackgroundColor: Colors.black,
);
