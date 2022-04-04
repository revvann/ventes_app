// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/state_controllers/regular_state_controller.dart';
import 'package:ventes/widgets/regular_dropdown.dart';

class ScheduleFormCreateStateController extends RegularStateController {
  final _typeActive = 0.obs;
  int get typeActive => _typeActive.value;
  set typeActive(int value) => _typeActive.value = value;

  final timeStartSelectController = DropdownController<String?>(null);
  final timeEndSelectController = DropdownController<String?>(null);

  final Completer<GoogleMapController> mapsController = Completer();
  late CameraPosition currentPos;

  final Rx<Set<Marker>> _markers = Rx<Set<Marker>>({});
  Set<Marker> get markers => _markers.value;
  set markers(Set<Marker> value) => _markers.value = value;

  final locationTED = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    createStartTimeList();
  }

  @override
  void onInit() async {
    super.onInit();
    Position pos = await getCurrentPosition();
    currentPos = CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 14.4764);
  }

  void createStartTimeList() {
    timeStartSelectController.items = _createItems();
    timeStartSelectController.value ??= timeStartSelectController.items.first['value'];
    createEndTimeList();
  }

  void createEndTimeList() {
    DateTime time = DateTime.parse("0000-00-00 ${timeStartSelectController.value}");
    timeEndSelectController.items = _createItems(time.hour, time.minute);
    timeEndSelectController.value ??= timeEndSelectController.items.first['value'];

    DateTime endTime = DateTime.parse("0000-00-00 ${timeEndSelectController.value}");
    if (time.millisecondsSinceEpoch > endTime.millisecondsSinceEpoch) {
      timeEndSelectController.value = timeStartSelectController.value;
    }
  }

  List<Map<String, dynamic>> _createItems([int? minHour, int? minMinutes]) {
    List<Map<String, dynamic>> items = [];
    DateTime time = DateTime(0, 0, 0, minHour ?? 0, minMinutes ?? 0);
    int limit = DateTime(0, 0, 0, 23, 59).difference(time).inMinutes ~/ 15;
    String text = DateFormat(DateFormat.HOUR_MINUTE).format(time);
    String value = DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(time);
    items.add({
      "text": text,
      "value": value,
    });

    for (int i = 1; i <= limit; i++) {
      time = time.add(Duration(minutes: 15));
      String text = DateFormat(DateFormat.HOUR_MINUTE).format(time);
      String value = DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(time);
      items.add({
        "text": text,
        "value": value,
      });
    }
    return items;
  }
}
