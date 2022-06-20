// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/resources/widgets/regular_bottom_sheet.dart';
import 'package:ventes/app/states/controllers/form_state_controller.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/form_sources/regular_form_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/notification_helper.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'dart:convert';

import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_dropdown.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/presenters/schedule_fc_presenter.dart';
import 'package:ventes/helpers/auth_helper.dart';

part 'package:ventes/app/states/form_validators/schedule_fc_validator.dart';
part 'package:ventes/app/states/data_sources/schedule_fc_data_source.dart';
part 'package:ventes/app/states/form_sources/schedule_fc_form_source.dart';
part 'package:ventes/app/states/listeners/schedule_fc_listener.dart';

class ScheduleFormCreateStateController extends FormStateController<_Properties, _Listener, _DataSource, _FormSource> {
  @override
  String get tag => ScheduleString.scheduleCreateTag;

  @override
  _Properties propertiesBuilder() => _Properties();

  @override
  _Listener listenerBuilder() => _Listener();

  @override
  _DataSource dataSourceBuilder() => _DataSource();

  @override
  _FormSource formSourceBuilder() => _FormSource();

  @override
  bool get isFixedBody => false;
}

class _Properties {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ScheduleString.scheduleCreateTag);
  _Listener get _listener => Get.find<_Listener>(tag: ScheduleString.scheduleCreateTag);
  _FormSource get _formSource => Get.find<_FormSource>(tag: ScheduleString.scheduleCreateTag);

  final Completer<GoogleMapController> mapsController = Completer();
  CameraPosition currentPos = CameraPosition(target: LatLng(0, 0), zoom: 14.4764);

  final Rx<Set<Marker>> _markers = Rx<Set<Marker>>({});

  Task task = Task(ScheduleString.createScheduleTaskCode);

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
    Get.find<TaskHelper>().loaderPush(task);
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
