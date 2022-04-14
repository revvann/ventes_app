// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/routing/routes/regular_route.dart';
import 'package:ventes/network/services/auth_service.dart';
import 'package:ventes/app/resources/views/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  runApp(const MyApp());
  Intl.defaultLocale = 'en_ID';
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ventes App',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
      ],
      locale: Locale('en'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createSwatch(RegularColor.primary),
        fontFamily: "Inter",
      ),
      getPages: RegularRoute.routes,
      initialRoute: SplashScreenView.route,
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => AuthService());
        Get.lazyPut(() => AuthHelper());
      }),
    );
  }
}
