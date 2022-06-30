// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:ventes/app/api/services/auth_service.dart';
import 'package:ventes/app/api/services/bp_customer_service.dart';
import 'package:ventes/app/api/services/contact_person_service.dart';
import 'package:ventes/app/api/services/customer_service.dart';
import 'package:ventes/app/api/services/gmaps_service.dart';
import 'package:ventes/app/api/services/place_service.dart';
import 'package:ventes/app/api/services/prospect_activity_service.dart';
import 'package:ventes/app/api/services/prospect_assign_service.dart';
import 'package:ventes/app/api/services/prospect_product_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/schedule_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/app/resources/views/splash_screen.dart';
import 'package:ventes/app/states/controllers/keyboard_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/notification_helper.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/routes/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  tz.initializeTimeZones();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  await FirebaseMessaging.instance.subscribeToTopic('round');

  runApp(const MyApp());
  Intl.defaultLocale = 'en_ID';
  Get.lazyPut(() => AuthService(), fenix: true);
  Get.lazyPut(() => AuthService(), fenix: true);
  Get.lazyPut(() => BpCustomerService(), fenix: true);
  Get.lazyPut(() => CustomerService(), fenix: true);
  Get.lazyPut(() => GmapsService(), fenix: true);
  Get.lazyPut(() => PlaceService(), fenix: true);
  Get.lazyPut(() => ProspectService(), fenix: true);
  Get.lazyPut(() => ScheduleService(), fenix: true);
  Get.lazyPut(() => TypeService(), fenix: true);
  Get.lazyPut(() => UserService(), fenix: true);
  Get.lazyPut(() => ProspectActivityService(), fenix: true);
  Get.lazyPut(() => ProspectProductService(), fenix: true);
  Get.lazyPut(() => ContactPersonService(), fenix: true);
  Get.lazyPut(() => ProspectAssignService(), fenix: true);
  Get.lazyPut(() => KeyboardStateController(), fenix: true);
  Get.lazyPut(() => ContactPersonService(), fenix: true);
  Get.lazyPut(() => AuthHelper(), fenix: true);
  Get.lazyPut(() => NotificationHelper(), fenix: true);
  Get.lazyPut(() => TaskHelper(), fenix: true);
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
