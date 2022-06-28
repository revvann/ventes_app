import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/resources/widgets/regular_bottom_sheet.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/app/states/typedefs/schedule_fc_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/notification_helper.dart';
import 'package:ventes/helpers/task_helper.dart';

class ScheduleFormCreateProperty extends StateProperty with PropertyMixin {
  final Completer<GoogleMapController> mapsController = Completer();
  CameraPosition currentPos = CameraPosition(target: LatLng(0, 0), zoom: 14.4764);
  Map<String, dynamic>? refData = {};

  final Rx<Set<Marker>> _markers = Rx<Set<Marker>>({});

  Task task = Task(ScheduleString.createScheduleTaskCode);

  final _hideReferenceField = Rx<bool>(false);
  bool get hideReferenceField => _hideReferenceField.value;
  set hideReferenceField(bool value) => _hideReferenceField.value = value;

  final _toggleReferenceText = Rx<String>("show");
  String get toggleReferenceText => _toggleReferenceText.value;
  set toggleReferenceText(String value) => _toggleReferenceText.value = value;
  void toggleText() {
    if (hideReferenceField) {
      toggleReferenceText = "hide";
    } else {
      toggleReferenceText = "show";
    }
  }

  final _referenceLabel = Rx<String>("Reference...");
  String get referenceLabel => _referenceLabel.value;
  set referenceLabel(String value) => _referenceLabel.value = value;
  void toggleLabel() {
    if (hideReferenceField) {
      referenceLabel = "Reference";
    } else {
      referenceLabel = "Reference...";
    }
  }

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
    Position pos = await getCurrentPosition();
    mapsController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)),
      );
    });
    markerLatLng = LatLng(pos.latitude, pos.longitude);
    dataSource.typesHandler.fetcher.run();
    if (formSource.schereftypeid != null) {
      dataSource.refTypeHandler.fetcher.run(formSource.schereftypeid!);
    }
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
        onCameraMove: listener.onCameraMove,
      );
    });
  }

  Future scheduleNotification() async {
    if (formSource.isEvent && formSource.scheremind != 0) {
      String title = "Ventes Schedule";
      DateTime? startTime = formSource.schestarttime;
      DateTime? startDate = formSource.schestartdate;
      DateTime date;

      if (!formSource.scheallday) {
        date = DateTime(startDate.year, startDate.month, startDate.day, startTime!.hour, startTime.minute);
      } else {
        date = DateTime(startDate.year, startDate.month, startDate.day, 0, 0);
      }

      date = date.subtract(Duration(minutes: formSource.scheremind));

      String message = "${formSource.schenm} will start in ${formSource.scheremind} minutes, be ready!";

      await Get.find<NotificationHelper>().scheduleNotification(
        title: title,
        body: message,
        scheduledDate: date,
        timeZone: formSource.schetz,
      );
    }
  }
}
