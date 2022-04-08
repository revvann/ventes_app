// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ventes/constants/app.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/presenters/schedule_fc_presenter.dart';
import 'package:ventes/state_controllers/regular_state_controller.dart';
import 'package:ventes/widgets/regular_dropdown.dart';

class ScheduleFormCreateStateController extends RegularStateController {
  ScheduleFormCreatePresenter presenter = ScheduleFormCreatePresenter();

  final _typeActive = 0.obs;
  final timeStartSelectController = DropdownController<String?>(null);
  final timeEndSelectController = DropdownController<String?>(null);

  final Completer<GoogleMapController> mapsController = Completer();
  late CameraPosition currentPos;

  final Rx<Set<Marker>> _markers = Rx<Set<Marker>>({});
  final locationTEC = TextEditingController();

  final dateStartTEC = TextEditingController();
  final dateEndTEC = TextEditingController();
  final linkTEC = TextEditingController();
  final remindTEC = TextEditingController();
  final descriptionTEC = TextEditingController();
  late DateTime dateStart;
  late DateTime dateEnd;

  Set<Marker> get markers => _markers.value;
  set markers(Set<Marker> value) => _markers.value = value;

  int get typeActive => _typeActive.value;
  set typeActive(int value) => _typeActive.value = value;

  final Rx<bool> _isOnline = Rx<bool>(false);
  bool get isOnline => _isOnline.value;
  set isOnline(bool value) => _isOnline.value = value;

  void createEndTimeList() {
    String timeStartValue = "${DateFormat('MMMM dd, yyyy').format(dateStart)} ${timeStartSelectController.value}";
    DateTime time = DateFormat("MMMM dd, yyyy HH:mm:ss").parse(timeStartValue);
    dateStart = dateStart.subtract(Duration(hours: dateStart.hour, minutes: dateStart.minute));
    dateStart = dateStart.add(Duration(hours: time.hour, minutes: time.minute));

    DateTime maxDate = DateTime(dateEnd.year, dateEnd.month, dateEnd.day, 23, 59);
    bool hasMoreTime = maxDate.difference(dateStart).inMinutes >= 15;
    if (hasMoreTime) {
      if (dateStart.difference(dateEnd).inSeconds >= 0) {
        timeEndSelectController.items = _createItems(dateStart.hour, dateStart.minute);
        dateStart = dateStart.add(Duration(minutes: 15));
        dateEnd = dateEnd.subtract(Duration(hours: dateEnd.hour, minutes: dateEnd.minute));
        dateEnd = dateEnd.add(Duration(hours: dateStart.hour, minutes: dateStart.minute));

        timeEndSelectController.items = _createItems(dateEnd.hour, dateEnd.minute);
        timeEndSelectController.value = DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(dateEnd);
      }
    } else {
      timeEndSelectController.items = _createItems();
      dateEnd = dateEnd.subtract(Duration(minutes: dateEnd.minute, hours: dateEnd.hour));
      dateEnd = dateEnd.add(Duration(days: 1, minutes: 15));
      timeEndSelectController.value = DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(dateEnd);
      dateEndTEC.text = DateFormat(viewDateFormat).format(dateEnd);
    }
    timeEndSelectController;
  }

  void createStartTimeList() {
    timeStartSelectController.items = _createItems();
    timeStartSelectController.value = DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(dateStart);
    timeEndSelectController.value = DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(dateEnd);
    createEndTimeList();
  }

  void allDayToggle(value) {
    if (value) {
      timeStartSelectController.value = null;
      timeStartSelectController.enabled = false;
      timeEndSelectController.value = null;
      timeEndSelectController.enabled = false;
    } else {
      timeStartSelectController.value = DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(dateStart);
      timeStartSelectController.enabled = true;
      timeEndSelectController.value = DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(dateEnd);
      timeEndSelectController.enabled = true;
    }
  }

  void onlineToggle(value) {
    isOnline = value;
  }

  @override
  void dispose() {
    locationTEC.dispose();
    dateStartTEC.dispose();
    dateEndTEC.dispose();
    super.dispose();
  }

  @override
  void onInit() async {
    super.onInit();
    DateTime currDate = DateTime.now();
    dateStart = DateTime(currDate.year, currDate.month, currDate.day);
    dateEnd = DateTime(currDate.year, currDate.month, currDate.day);

    Position pos = await getCurrentPosition();
    currentPos = CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 14.4764);

    presenter.fetchUser();
  }

  @override
  void onReady() {
    super.onReady();
    createStartTimeList();
    dateStartTEC.text = DateFormat('MMMM dd, yyyy').format(dateStart);
    dateEndTEC.text = DateFormat('MMMM dd, yyyy').format(dateEnd);
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
