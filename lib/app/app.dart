/*
* ТУТ ВСЯ ЛОГИКА ЗАПУУСКА И СБОРА ПРИЛОЖЕНИЯ - DJPDHFOTYBYT  MATERIAL APP
* подключить router и theme
* Логика показа 1ого экрана - StartPage если не авторизован, HomePage - если автооризован
*/
import 'package:flutter/material.dart';
import '../features/home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage()
    );
  }
}