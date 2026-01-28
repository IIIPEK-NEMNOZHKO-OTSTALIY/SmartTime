/*
* ТУТ ВСЯ ЛОГИКА ЗАПУУСКА И СБОРА ПРИЛОЖЕНИЯ - DJPDHFOTYBYT  MATERIAL APP
* подключить router и theme
* Логика показа 1ого экрана - StartPage если не авторизован, HomePage - если автооризован
*/

import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: HomePage()
    );
  }
}