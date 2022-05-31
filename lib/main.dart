// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ventes/app/network/services/bp_customer_service.dart';
import 'package:ventes/app/network/services/contact_person_service.dart';
import 'package:ventes/app/network/services/customer_service.dart';
import 'package:ventes/app/network/services/gmaps_service.dart';
import 'package:ventes/app/network/services/place_service.dart';
import 'package:ventes/app/network/services/prospect_detail_service.dart';
import 'package:ventes/app/network/services/prospect_service.dart';
import 'package:ventes/app/network/services/schedule_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/app/states/controllers/keyboard_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/routes/routes.dart';
import 'package:ventes/app/network/services/auth_service.dart';
import 'package:ventes/app/resources/views/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  runApp(const MyApp());
  Intl.defaultLocale = 'en_ID';
  Get.lazyPut(() => AuthService(), fenix: true);
  Get.lazyPut(() => AuthHelper(), fenix: true);
  Get.lazyPut(() => TaskHelper(), fenix: true);
  Get.lazyPut(() => AuthService(), fenix: true);
  Get.lazyPut(() => BpCustomerService(), fenix: true);
  Get.lazyPut(() => CustomerService(), fenix: true);
  Get.lazyPut(() => GmapsService(), fenix: true);
  Get.lazyPut(() => PlaceService(), fenix: true);
  Get.lazyPut(() => ProspectService(), fenix: true);
  Get.lazyPut(() => ScheduleService(), fenix: true);
  Get.lazyPut(() => TypeService(), fenix: true);
  Get.lazyPut(() => UserService(), fenix: true);
  Get.lazyPut(() => ProspectDetailService(), fenix: true);
  Get.lazyPut(() => ContactPersonService(), fenix: true);
  Get.lazyPut(() => KeyboardStateController(), fenix: true);
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
      getPages: Routes.all,
      initialRoute: SplashScreenView.route,
    );
  }
}
