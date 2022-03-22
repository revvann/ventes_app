// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/routes/regular_route.dart';
import 'package:ventes/views/splash_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ventes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createSwatch(RegularColor.primary),
        fontFamily: "Inter",
      ),
      getPages: RegularRoute.routes,
      initialRoute: SplashScreenView.route,
    );
  }
}
