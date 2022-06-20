import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:timezone/timezone.dart';
import 'package:intl/intl.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/app/states/controllers/bottom_navigation_state_controller.dart';

MaterialColor createSwatch(Color color) {
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

List<Location> getTimezoneLocation() {
  LocationDatabase tzDb = timeZoneDatabase;
  return tzDb.locations.values.toList();
}

List<Map<String, String>> getTimezoneList() {
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

Future<Position> getCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

DateTime dbParseDate(String date) {
  return DateFormat('yyyy-MM-dd').parse(date);
}

DateTime parseDate(String date) {
  return DateFormat('MMMM dd, yyyy').parse(date);
}

DateTime parseTime(String time) {
  return DateFormat('HH:mm:ss').parse(time);
}

DateTime parseTime12(String time) {
  return DateFormat('HH:mm a').parse(time);
}

DateTime parseDateTime(String dateTime) {
  return DateFormat('MMMM dd, yyyy HH:mm:ss').parse(dateTime);
}

String dbFormatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatDate(DateTime date) {
  return DateFormat('MMMM dd, yyyy').format(date);
}

String formatTime(DateTime time) {
  return DateFormat('HH:mm:ss').format(time);
}

String formatTime12(DateTime time) {
  return DateFormat('HH:mm a').format(time);
}

String formatDateTime(DateTime dateTime) {
  return DateFormat('MMMM dd, yyyy HH:mm:ss').format(dateTime);
}

String dbDateFormat(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

DateTime firstWeekDate(DateTime date) {
  return date.subtract(Duration(days: date.weekday - 1));
}

DateTime lastWeekDate(DateTime date) {
  return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
}

List<Map<String, dynamic>> createTimeList([int? minHour, int? minMinutes]) {
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

void backToDashboard() {
  Get.find<BottomNavigationStateController>().currentIndex = Views.dashboard;
}

///
/// unit is meter
///
double calculateDistance(LatLng coords1, LatLng coords2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((coords2.latitude - coords1.latitude) * p) / 2 + c(coords1.latitude * p) * c(coords2.latitude * p) * (1 - c((coords2.longitude - coords1.longitude) * p)) / 2;
  return (12742 * asin(sqrt(a))) * 1000;
}

String currencyFormat(String number) {
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

String getInitials(String name) {
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
