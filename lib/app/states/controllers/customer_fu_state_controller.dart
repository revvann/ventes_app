// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/customer_fu_data_source.dart';
import 'package:ventes/app/states/form_sources/customer_fu_form_source.dart';
import 'package:ventes/app/states/listeners/customer_fu_listener.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class CustomerFormUpdateStateController extends RegularStateController {
  CustomerFormUpdateDataSource dataSource = Get.put(CustomerFormUpdateDataSource());
  CustomerFormUpdateProperties properties = Get.put(CustomerFormUpdateProperties());
  CustomerFormUpdateListener listener = Get.put(CustomerFormUpdateListener());
  CustomerFormUpdateFormSource formSource = Get.put(CustomerFormUpdateFormSource());

  @override
  onInit() {
    super.onInit();
    dataSource.init();
    formSource.init();
  }

  @override
  void onReady() async {
    super.onReady();
    properties.ready();
    properties.refresh();
  }

  @override
  void onClose() {
    Get.delete<CustomerFormUpdateProperties>();
    Get.delete<CustomerFormUpdateListener>();
    Get.delete<CustomerFormUpdateFormSource>();
    super.onClose();
  }
}

class CustomerFormUpdateProperties {
  CustomerFormUpdateFormSource get _formSource => Get.find<CustomerFormUpdateFormSource>();
  CustomerFormUpdateDataSource get _dataSource => Get.find<CustomerFormUpdateDataSource>();

  final double defaultZoom = 20;
  final Completer<GoogleMapController> mapsController = Completer();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey bottomSheetKey = GlobalKey();
  GlobalKey stackKey = GlobalKey();

  CameraMoveType cameraMoveType = CameraMoveType.controller;
  int? customerid;

  final Rx<double> mapsHeight = Rx<double>(0);
  final Rx<double> bottomSheetHeight = Rx<double>(0);

  final Rx<Set<Marker>> _markers = Rx<Set<Marker>>({});
  Set<Marker> get markers => _markers.value;
  set markers(Set<Marker> value) => _markers.value = value;
  set markerLatLng(LatLng latlng) {
    Marker marker = Marker(
      markerId: MarkerId(NearbyString.selectedLocId),
      infoWindow: InfoWindow(title: _formSource.cstmname),
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

  Future moveCamera() async {
    if (_dataSource.bpCustomer != null) {
      LatLng pos = LatLng(_dataSource.bpCustomer!.sbccstm!.cstmlatitude!, _dataSource.bpCustomer!.sbccstm!.cstmlongitude!);
      GoogleMapController controller = await mapsController.future;
      await controller.animateCamera(
        CameraUpdate.newLatLng(pos),
      );
      markerLatLng = pos;
    }
  }

  void refresh() {
    _dataSource.fetchData(customerid ?? 0);
    Get.find<TaskHelper>().add(NearbyString.updateTaskCode);
  }
}
