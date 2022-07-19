// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:ventes/app/resources/views/splash_screen.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/routing/routes/routes.dart';
import 'package:ventes/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  Utils.initRoutePack();
  await Utils.initNotification();
  Utils.initServices();
  tz.initializeTimeZones();
  await Utils.initFirebase();

  runApp(const MyApp());
  Intl.defaultLocale = 'en_ID';
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ventes App',
      onDispose: onDispose,
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
        primarySwatch: Utils.createSwatch(RegularColor.primary),
        fontFamily: "Inter",
      ),
      getPages: Routes.all,
      initialRoute: SplashScreenView.route,
    );
  }

  void onDispose() {
    print("testestes");
  }
}
