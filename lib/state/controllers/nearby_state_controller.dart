// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/state/controllers/regular_state_controller.dart';
import 'package:ventes/state/data_sources/nearby_data_source.dart';
import 'package:ventes/state/listeners/nearby_listener.dart';

class NearbyStateController extends RegularStateController with NearbyListener {
  NearbyDataSource dataSource = NearbyDataSource();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey bottomSheetKey = GlobalKey();
  GlobalKey stackKey = GlobalKey();

  final Rx<double> mapsHeight = Rx<double>(0);
  final Rx<double> bottomSheetHeight = Rx<double>(0);

  final Completer<GoogleMapController> mapsController = Completer();

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
  void onInit() async {
    super.onInit();

    Position position = await getCurrentPosition();
    GoogleMapController controller = await mapsController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
    dataSource.getDetail(LatLng(position.latitude, position.longitude));
    Loader().show();
  }

  @override
  onReady() {
    super.onReady();
    double bottomSheetHeight = bottomSheetKey.currentContext?.size?.height ?? 0;
    double stackHeight = stackKey.currentContext?.size?.height ?? 0;
    this.bottomSheetHeight.value = stackHeight - RegularSize.l;
    mapsHeight.value = (stackHeight - bottomSheetHeight) + 10;
  }
}
