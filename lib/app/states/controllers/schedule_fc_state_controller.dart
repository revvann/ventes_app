// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/resources/widgets/regular_bottom_sheet.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/schedule_fc_data_source.dart';
import 'package:ventes/app/states/form_sources/schedule_fc_form_source.dart';
import 'package:ventes/app/states/listeners/schedule_fc_listener.dart';
import 'package:ventes/helpers/notification_helper.dart';
import 'package:ventes/helpers/task_helper.dart';

class ScheduleFormCreateStateController extends RegularStateController {
  @override
  bool get isFixedBody => false;

  ScheduleFormCreateDataSource dataSource = Get.put(ScheduleFormCreateDataSource());
  ScheduleFormCreateListener listener = Get.put(ScheduleFormCreateListener());
  ScheduleFormCreateFormSource formSource = Get.put(ScheduleFormCreateFormSource());
  ScheduleFormCreateProperties properties = Get.put(ScheduleFormCreateProperties());

  @override
  void onClose() {
    formSource.formSourceDispose();
    Get.delete<ScheduleFormCreateProperties>();
    Get.delete<ScheduleFormCreateListener>();
    Get.delete<ScheduleFormCreateFormSource>();
    Get.delete<ScheduleFormCreateDataSource>();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    dataSource.init();
    formSource.init();
  }

  @override
  void onReady() async {
    super.onReady();
    properties.refresh();
  }
}

class ScheduleFormCreateProperties {
  ScheduleFormCreateDataSource get _dataSource => Get.find<ScheduleFormCreateDataSource>();
  ScheduleFormCreateListener get _listener => Get.find<ScheduleFormCreateListener>();
  ScheduleFormCreateFormSource get _formSource => Get.find<ScheduleFormCreateFormSource>();

  final Completer<GoogleMapController> mapsController = Completer();
  CameraPosition currentPos = CameraPosition(target: LatLng(0, 0), zoom: 14.4764);

  final Rx<Set<Marker>> _markers = Rx<Set<Marker>>({});

  Set<Marker> get markers => _markers.value;
  set markers(Set<Marker> value) => _markers.value = value;
  set markerLatLng(LatLng latlng) {
    Marker marker = Marker(
      markerId: MarkerId("selectedloc"),
      infoWindow: InfoWindow(title: "Selected Location"),
      position: latlng,
    );
    markers = {marker};
  }

  void refresh() async {
    Get.find<TaskHelper>().loaderPush(ScheduleString.createScheduleTaskCode);
    Position pos = await getCurrentPosition();
    mapsController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)),
      );
    });
    markerLatLng = LatLng(pos.latitude, pos.longitude);
    _dataSource.fetchTypes();
  }

  void showMapBottomSheet() {
    RegularBottomSheet(
      backgroundColor: Colors.white,
      enableDrag: false,
      child: Column(
        children: [
          SizedBox(
            height: RegularSize.m,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose Location",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: RegularColor.secondary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (markers.isNotEmpty) {
                    currentPos = CameraPosition(target: markers.first.position, zoom: currentPos.zoom);
                  }
                  Get.close(1);
                },
                child: Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 16,
                    color: RegularColor.red,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          SizedBox(
            height: Get.height * 0.4,
            child: _gMaps,
          ),
          SizedBox(
            height: RegularSize.m,
          ),
        ],
      ),
    ).show();
  }

  Widget get _gMaps {
    return Obx(() {
      return GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: currentPos,
        markers: markers,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          if (!mapsController.isCompleted) {
            mapsController.complete(controller);
          }
        },
        onCameraMove: _listener.onCameraMove,
      );
    });
  }

  Future scheduleNotification() async {
    if (_formSource.isEvent && _formSource.scheremind != 0) {
      String title = "Ventes Schedule";
      DateTime? startTime = _formSource.schestarttime;
      DateTime? startDate = _formSource.schestartdate;
      DateTime date;

      if (!_formSource.scheallday) {
        date = DateTime(startDate.year, startDate.month, startDate.day, startTime!.hour, startTime.minute);
      } else {
        date = DateTime(startDate.year, startDate.month, startDate.day, 0, 0);
      }

      date = date.subtract(Duration(minutes: _formSource.scheremind));

      String message = "${_formSource.schenm} will start in ${_formSource.scheremind} minutes, be ready!";

      await Get.find<NotificationHelper>().scheduleNotification(
        title: title,
        body: message,
        scheduledDate: date,
        timeZone: _formSource.schetz,
      );
    }
  }
}
