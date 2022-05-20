// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/nearby_data_source.dart';
import 'package:ventes/app/states/listeners/nearby_listener.dart';
import 'package:ventes/helpers/task_helper.dart';

class NearbyStateController extends RegularStateController {
  NearbyDataSource dataSource = Get.put(NearbyDataSource());
  NearbyListener listener = Get.put(NearbyListener());
  NearbyProperties properties = Get.put(NearbyProperties());

  @override
  bool get isFixedBody => false;

  @override
  void onInit() async {
    super.onInit();
    properties.refresh();
    dataSource.init();
  }

  @override
  onReady() {
    super.onReady();
    properties.ready();
  }

  @override
  void onClose() {
    Get.delete<NearbyProperties>();
    Get.delete<NearbyListener>();
    Get.delete<NearbyDataSource>();
    super.onClose();
  }
}

class NearbyProperties {
  final NearbyDataSource _dataSource = Get.find<NearbyDataSource>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey bottomSheetKey = GlobalKey();
  GlobalKey stackKey = GlobalKey();

  CameraMoveType cameraMoveType = CameraMoveType.controller;

  final Rx<List<Customer>> _selectedCustomer = Rx<List<Customer>>([]);

  final Rx<double> mapsHeight = Rx<double>(0);
  final Rx<double> bottomSheetHeight = Rx<double>(0);

  final double defaultZoom = 20;

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

  set selectedCustomer(List<Customer> customer) => _selectedCustomer.value = customer;
  List<Customer> get selectedCustomer => _selectedCustomer.value;

  void ready() {
    double bottomSheetHeight = bottomSheetKey.currentContext?.size?.height ?? 0;
    double stackHeight = stackKey.currentContext?.size?.height ?? 0;
    this.bottomSheetHeight.value = stackHeight - RegularSize.l;
    mapsHeight.value = (stackHeight - bottomSheetHeight) + 10;
  }

  void deployCustomers(List<Customer> data) async {
    List<Marker> markersList = [markers.first];
    for (var element in data) {
      bool isInBp = _dataSource.bpCustomersHas(element);
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
    Position position = await getCurrentPosition();
    GoogleMapController controller = await mapsController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
    _dataSource.fetchData(LatLng(position.latitude, position.longitude));
    Get.find<TaskHelper>().add(NearbyString.taskCode);
  }
}

enum CameraMoveType { dragged, controller }
