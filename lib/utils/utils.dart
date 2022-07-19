import 'dart:async';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:timezone/timezone.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/app/api/services/auth_service.dart';
import 'package:ventes/app/api/services/bp_customer_service.dart';
import 'package:ventes/app/api/services/chat_service.dart';
import 'package:ventes/app/api/services/competitor_service.dart';
import 'package:ventes/app/api/services/contact_person_service.dart';
import 'package:ventes/app/api/services/customer_service.dart';
import 'package:ventes/app/api/services/files_service.dart';
import 'package:ventes/app/api/services/gmaps_service.dart';
import 'package:ventes/app/api/services/notification_service.dart';
import 'package:ventes/app/api/services/place_service.dart';
import 'package:ventes/app/api/services/prospect_activity_service.dart';
import 'package:ventes/app/api/services/prospect_assign_service.dart';
import 'package:ventes/app/api/services/prospect_product_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/schedule_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/app/resources/views/dashboard/dashboard.dart';
import 'package:ventes/app/states/controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/app/states/controllers/keyboard_state_controller.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/firebase_options.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/notification_helper.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/route_pack.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class Utils {
  static MaterialColor createSwatch(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final lightness = hslColor.lightness;

    const lowDivisor = 6;
    const highDivisor = 5;

    final lowStep = (1.0 - lightness) / lowDivisor;
    final highStep = lightness / highDivisor;
    return MaterialColor(color.value, {
      50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
      200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
      300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
      400: (hslColor.withLightness(lightness + lowStep)).toColor(),
      500: (hslColor.withLightness(lightness)).toColor(),
      600: (hslColor.withLightness(lightness - highStep)).toColor(),
      700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
      800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
      900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
    });
  }

  static Future<void> launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await url_launcher.canLaunchUrl(uri)) {
      Get.find<TaskHelper>().failedPush(Task('lauchurl', message: "Cannot launch url", snackbar: true));
    } else {
      url_launcher.launchUrl(uri);
    }
  }

  static Future requestPermission() async {
    await Permission.contacts.request();
    await Permission.location.request();
    await Permission.storage.request();
  }

  static List<Location> getTimezoneLocation() {
    LocationDatabase tzDb = timeZoneDatabase;
    return tzDb.locations.values.toList();
  }

  static List<Map<String, String>> getTimezoneList() {
    List<Location> locations = getTimezoneLocation();
    locations = locations..sort((a, b) => a.currentTimeZone.offset.compareTo(b.currentTimeZone.offset));
    return locations.map((location) {
      int offset = location.currentTimeZone.offset ~/ (1000 * 60 * 60);
      String sign = offset >= 0 ? '+' : '';
      String gmt = "GMT$sign$offset";
      return {
        'value': location.name,
        'text': "($gmt) ${location.name}",
      };
    }).toList();
  }

  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  static DateTime dbParseDate(String date) {
    return DateFormat('yyyy-MM-dd').parse(date);
  }

  static DateTime parseDate(String date) {
    return DateFormat('MMMM dd, yyyy').parse(date);
  }

  static DateTime parseTime(String time) {
    return DateFormat('HH:mm:ss').parse(time);
  }

  static DateTime parseTime12(String time) {
    return DateFormat('HH:mm a').parse(time);
  }

  static DateTime parseDateTime(String dateTime) {
    return DateFormat('MMMM dd, yyyy HH:mm:ss').parse(dateTime);
  }

  static DateTime dbParseDateTime(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  }

  static String dbformatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm:ss').format(time);
  }

  static String formatTime12(DateTime time) {
    return DateFormat('HH:mm a').format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMMM dd, yyyy HH:mm:ss').format(dateTime);
  }

  static String dbDateFormat(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String dbFormatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static DateTime firstWeekDate(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static DateTime lastWeekDate(DateTime date) {
    return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
  }

  static List<Map<String, dynamic>> createTimeList([int? minHour, int? minMinutes]) {
    List<Map<String, dynamic>> items = [];
    DateTime time = DateTime(0, 0, 0, minHour ?? 0, minMinutes ?? 0);
    int limit = DateTime(0, 0, 0, 23, 59).difference(time).inMinutes ~/ 15;
    String text = DateFormat(DateFormat.HOUR_MINUTE).format(time);
    String value = formatTime(time);
    items.add({
      "text": text,
      "value": value,
    });

    for (int i = 1; i <= limit; i++) {
      time = time.add(Duration(minutes: 15));
      String text = DateFormat(DateFormat.HOUR_MINUTE).format(time);
      String value = formatTime(time);
      items.add({
        "text": text,
        "value": value,
      });
    }
    return items;
  }

  static void backToDashboard() {
    Get.find<BottomNavigationStateController>().currentIndex = Views.dashboard;
  }

  ///
  /// unit is meter
  ///
  static double calculateDistance(LatLng coords1, LatLng coords2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((coords2.latitude - coords1.latitude) * p) / 2 + c(coords1.latitude * p) * c(coords2.latitude * p) * (1 - c((coords2.longitude - coords1.longitude) * p)) / 2;
    return (12742 * asin(sqrt(a))) * 1000;
  }

  static String currencyFormat(String number) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    var value = number.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
    if (value.isEmpty) {
      value = '0';
    }
    return formatter.format(double.parse(value));
  }

  static String getInitials(String name) {
    if (name.isEmpty) {
      return '';
    }
    var names = name.split(' ');
    if (names.length == 1) {
      return names[0].substring(0, 2).toUpperCase();
    }
    var initials = '';
    for (var name in names.getRange(0, 2)) {
      initials += name[0];
    }
    return initials;
  }

  static Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId;
  }

  static void showError(String id, String message) {
    Get.find<TaskHelper>().errorPush(Task(id, message: message));
  }

  static void showSuccess(String id, String message) {
    Get.find<TaskHelper>().successPush(Task(id, message: message));
  }

  static void showFailed(String id, String message, [bool snackbar = true]) {
    Get.find<TaskHelper>().failedPush(Task(id, message: message, snackbar: snackbar));
  }

  static DataHandler<D, R, F> createDataHandler<D, R, F extends Function>(String id, DataFetcher<F, R> fetcher, D initialValue, D Function(R) onSuccess,
      {Function()? onComplete, Function()? onStart}) {
    return DataHandler<D, R, F>(
      id,
      initialValue: initialValue,
      fetcher: fetcher,
      onFailed: (message) => showFailed(id, message),
      onError: (message) => showError(id, message),
      onSuccess: onSuccess,
      onStart: onStart,
      onComplete: onComplete,
    );
  }

  static Future initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.subscribeToTopic('terabithians');

    FirebaseMessaging.onMessage.listen((event) async {
      Map<String, String> payload = event.data.map((key, value) => MapEntry(key, value.toString()))..removeWhere((key, value) => ['title', 'body', 'id', 'date'].contains(key));
      NotificationSchedule? schedule;

      if (event.data['date'] != null) {
        DateTime date = dbParseDateTime(event.data['date']);
        schedule = NotificationCalendar.fromDate(date: date);
      }

      await Get.find<NotificationHelper>().create(
        content: NotificationContent(
          id: int.tryParse(event.data['id']) ?? 0,
          channelKey: NotificationString.channelKey,
          title: event.data['title'],
          body: event.data['body'],
          payload: payload,
        ),
        schedule: schedule,
      );
    });
  }

  static void initRoutePack() {
    try {
      Get.find<Rx<RoutePack>>();
    } catch (e) {
      Rx<RoutePack> routePack = Rx<RoutePack>(RoutePack(Views.dashboard, DashboardView.route));
      Get.put(routePack);
    }
  }

  static Future initNotification() async {
    try {
      Get.find<NotificationHelper>();
    } catch (e) {
      NotificationHelper notificationHelper = NotificationHelper();
      await notificationHelper.init();
      Get.put(notificationHelper);
    }
  }

  static void initServices() {
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => UserService(), fenix: true);
    Get.lazyPut(() => ChatService(), fenix: true);
    Get.lazyPut(() => CompetitorService(), fenix: true);
    Get.lazyPut(() => BpCustomerService(), fenix: true);
    Get.lazyPut(() => CustomerService(), fenix: true);
    Get.lazyPut(() => GmapsService(), fenix: true);
    Get.lazyPut(() => PlaceService(), fenix: true);
    Get.lazyPut(() => ProspectService(), fenix: true);
    Get.lazyPut(() => ScheduleService(), fenix: true);
    Get.lazyPut(() => TypeService(), fenix: true);
    Get.lazyPut(() => FilesService(), fenix: true);
    Get.lazyPut(() => ProspectActivityService(), fenix: true);
    Get.lazyPut(() => ProspectProductService(), fenix: true);
    Get.lazyPut(() => ContactPersonService(), fenix: true);
    Get.lazyPut(() => ProspectAssignService(), fenix: true);
    Get.lazyPut(() => NotificationService(), fenix: true);
    Get.lazyPut(() => KeyboardStateController(), fenix: true);
    Get.lazyPut(() => ContactPersonService(), fenix: true);
    Get.lazyPut(() => AuthHelper(), fenix: true);
    Get.lazyPut(() => TaskHelper(), fenix: true);
  }

  static void initSocket() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();

    OptionBuilder optionsBuilder = OptionBuilder();
    optionsBuilder.setTransports(['websocket']);
    optionsBuilder.setAuth(authModel!.toJson());
    Map<String, dynamic> options = optionsBuilder.build();

    Socket socket = io(RegularString.nodeServer, options);
    socket.onConnect((data) => onSocketConnect(data, socket.id));
    socket.onConnectError(onSocketConnectError);
    socket.onDisconnect(onSocketDisconnect);

    socket = socket.connect();
    Get.lazyPut<Socket>(() => socket, fenix: true);
  }

  static void onSocketConnect(data, socketid) {
    Get.find<UserService>().setSocketId(socketid);
    printSocket(socketid);
  }

  static void onSocketConnectError(data) {
    printSocket(data);
  }

  static void onSocketDisconnect(data) {
    printSocket(data);
  }

  static void printSocket(dynamic data) {
    print("socket: $data");
  }

  static void printFirebase(dynamic data) {
    print("firebase: $data");
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {
  Map<String, String> payload = message.data.map((key, value) => MapEntry(key, value.toString()))..removeWhere((key, value) => ['title', 'body'].contains(key));
  Utils.initRoutePack();
  await Utils.initNotification();
  await Get.find<NotificationHelper>().create(
    content: NotificationContent(
      id: 1,
      channelKey: 'ventes-123',
      title: message.data['title'],
      body: message.data['body'],
      payload: payload,
    ),
  );
}
