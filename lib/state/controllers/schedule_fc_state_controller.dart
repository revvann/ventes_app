// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/resources/widgets/regular_bottom_sheet.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/state/controllers/regular_state_controller.dart';
import 'package:ventes/state/data_sources/schedule_fc_data_source.dart';
import 'package:ventes/state/form_sources/schedule_fc_form_source.dart';
import 'package:ventes/state/listeners/schedule_fc_listener.dart';

class ScheduleFormCreateStateController extends RegularStateController with ScheduleFormCreateListener, ScheduleFormCreateFormSource {
  ScheduleFormCreateDataSource dataSource = ScheduleFormCreateDataSource();

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

  @override
  void dispose() {
    formSourceDispose();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    formSourceInit();
  }

  @override
  void onReady() async {
    super.onReady();
    Position pos = await getCurrentPosition();
    GoogleMapController controller = await mapsController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)),
    );
    markerLatLng = LatLng(pos.latitude, pos.longitude);
    dataSource.fetchTypes();
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
        onCameraMove: (position) {
          markerLatLng = position.target;
          scheloc = "https://maps.google.com?q=${position.target.latitude},${position.target.longitude}";
        },
      );
    });
  }
}
