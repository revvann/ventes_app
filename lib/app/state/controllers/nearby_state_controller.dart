// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/app/state/controllers/regular_state_controller.dart';
import 'package:ventes/app/state/data_sources/nearby_data_source.dart';
import 'package:ventes/app/state/listeners/nearby_listener.dart';

class NearbyStateController extends RegularStateController {
  NearbyProperties properties = Get.put(NearbyProperties());
  NearbyListener listener = Get.put(NearbyListener());

  @override
  void onInit() async {
    super.onInit();

    properties.dataSource.fetchDataContract = listener;

    Position position = await getCurrentPosition();
    GoogleMapController controller = await properties.mapsController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
    properties.dataSource.fetchData(LatLng(position.latitude, position.longitude));
    Loader().show();
  }

  @override
  onReady() {
    super.onReady();
    double bottomSheetHeight = properties.bottomSheetKey.currentContext?.size?.height ?? 0;
    double stackHeight = properties.stackKey.currentContext?.size?.height ?? 0;
    properties.bottomSheetHeight.value = stackHeight - RegularSize.l;
    properties.mapsHeight.value = (stackHeight - bottomSheetHeight) + 10;
  }

  @override
  void onClose() {
    Get.delete<NearbyProperties>();
    Get.delete<NearbyListener>();
    super.onClose();
  }
}

class NearbyProperties {
  NearbyDataSource dataSource = NearbyDataSource();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey bottomSheetKey = GlobalKey();
  GlobalKey stackKey = GlobalKey();

  final Rx<double> mapsHeight = Rx<double>(0);
  final Rx<double> bottomSheetHeight = Rx<double>(0);

  final double defaultZoom = 14.5;

  final Completer<GoogleMapController> mapsController = Completer();

  final Rx<Set<Marker>> _markers = Rx<Set<Marker>>({});
  Set<Marker> get markers => _markers.value;
  set markers(Set<Marker> value) => _markers.value = value;
  set markerLatLng(LatLng latlng) {
    Marker marker = Marker(
      markerId: MarkerId(NearbyString.selectedLocId),
      infoWindow: InfoWindow(title: NearbyString.selectedLocName),
      position: latlng,
    );

    if (markers.isNotEmpty) {
      List<Marker> markersList = markers.toList();
      markersList[0] = marker;
      markers = Set.from(markersList);
    } else {
      markers = {marker};
    }
  }

  void deployCustomers(List data) {
    dataSource.customersFromList(data);

    List<Marker> markersList = [markers.first];
    for (var element in dataSource.customers) {
      Marker marker = Marker(
        markerId: MarkerId((element.sbcid ?? "0").toString()),
        infoWindow: InfoWindow(title: element.sbccstmname ?? "Unknown"),
        position: LatLng(element.sbccstm!.cstmlatitude!, element.sbccstm!.cstmlongitude!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      );
      markersList.add(marker);
    }
    markers = Set.from(markersList);
  }
}
