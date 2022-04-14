// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ventes/constants/app.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/models/user_detail_model.dart';
import 'package:ventes/presenters/schedule_fc_presenter.dart';
import 'package:ventes/resources/data_sources/schedule_fc_data_source.dart';
import 'package:ventes/state_controllers/regular_state_controller.dart';
import 'package:ventes/resources/form_sources/schedule_fc_form_source.dart';
import 'package:ventes/widgets/regular_bottom_sheet.dart';
import 'package:ventes/widgets/regular_dropdown.dart';

class ScheduleFormCreateStateController extends RegularStateController {
  ScheduleFormCreateFormSource formSource = ScheduleFormCreateFormSource();
  ScheduleFormCreateDataSource dataSource = ScheduleFormCreateDataSource();

  final Completer<GoogleMapController> mapsController = Completer();
  late CameraPosition currentPos;

  final Rx<Set<Marker>> _markers = Rx<Set<Marker>>({});

  Set<Marker> get markers => _markers.value;
  set markers(Set<Marker> value) => _markers.value = value;

  @override
  void dispose() {
    formSource.dispose();
    super.dispose();
  }

  @override
  void onInit() async {
    super.onInit();
    formSource.dataSource = dataSource;
    formSource.init();

    Position pos = await getCurrentPosition();
    currentPos = CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 14.4764);
    dataSource.fetchUser();
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
          Container(
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
        mapType: MapType.hybrid,
        initialCameraPosition: currentPos,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          if (!mapsController.isCompleted) {
            mapsController.complete(controller);
          }
        },
        onTap: (latLng) {
          Marker marker = Marker(
            markerId: MarkerId("selectedloc"),
            infoWindow: InfoWindow(title: "Selected Location"),
            position: latLng,
          );
          formSource.scheloc = "https://maps.google.com?q=${latLng.latitude},${latLng.longitude}";
          markers = {marker};
        },
      );
    });
  }

  void createSchedule() {
    Map<String, dynamic> data = formSource.toJson();
    dataSource.createSchedule(data);
  }
}
