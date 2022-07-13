import 'dart:async';

import 'package:flutter/material.dart' hide MenuItem;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/api/models/customer_model.dart';
import 'package:ventes/app/states/typedefs/nearby_typedef.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';

class NearbyProperty extends StateProperty with PropertyMixin {
  Task task = Task(NearbyString.taskCode);

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey bottomSheetKey = GlobalKey();
  GlobalKey stackKey = GlobalKey();

  final Rx<List<Customer>> _selectedCustomer = Rx<List<Customer>>([]);

  final Completer<GoogleMapController> mapsController = Completer();
  CameraMoveType cameraMoveType = CameraMoveType.controller;

  final Rx<double> mapsHeight = Rx<double>(0);
  final Rx<double> bottomSheetHeight = Rx<double>(0);
  final double defaultZoom = 20;

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

  set selectedCustomer(List<Customer> customer) => _selectedCustomer.value = customer;
  List<Customer> get selectedCustomer => _selectedCustomer.value;

  void deployCustomers(List<Customer> data) async {
    List<Marker> markersList = [markers.first]; // bug no element
    for (var element in data) {
      bool isInBp = dataSource.bpCustomersHas(element);
      Marker marker = Marker(
        markerId: MarkerId((element.cstmid ?? "0").toString()),
        infoWindow: InfoWindow(title: element.cstmname ?? "Unknown"),
        position: LatLng(element.cstmlatitude!, element.cstmlongitude!),
        icon: BitmapDescriptor.defaultMarkerWithHue(isInBp ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueCyan),
      );
      markersList.add(marker);
    }
    markers = Set.from(markersList);
  }

  void refresh() async {
    Position position = await Utils.getCurrentPosition();
    GoogleMapController controller = await mapsController.future;
    await controller.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
    dataSource.bpCustomersHandler.fetcher.run();
    dataSource.locationHandler.fetcher.run(position.latitude, position.longitude);
  }

  @override
  void ready() {
    super.ready();
    double bottomSheetHeight = bottomSheetKey.currentContext?.size?.height ?? 0;
    double stackHeight = stackKey.currentContext?.size?.height ?? 0;
    this.bottomSheetHeight.value = stackHeight - RegularSize.l;
    mapsHeight.value = (stackHeight - bottomSheetHeight) + 10;
  }
}

enum CameraMoveType { dragged, controller }
