import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme(),
      title: 'Smart Time',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
      locale: Locale('ru', 'RU'),

      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}