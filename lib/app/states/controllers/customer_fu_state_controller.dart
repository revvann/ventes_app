// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/states/controllers/form_state_controller.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/states/form_sources/update_form_source.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/presenters/customer_fu_presenter.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:path/path.dart' as path;
import 'package:ventes/app/resources/widgets/search_list.dart';

part 'package:ventes/app/states/form_sources/customer_fu_form_source.dart';
part 'package:ventes/app/states/listeners/customer_fu_listener.dart';
part 'package:ventes/app/states/data_sources/customer_fu_data_source.dart';
part 'package:ventes/app/states/form_validators/customer_fu_validator.dart';

class CustomerFormUpdateStateController extends FormStateController<_Properties, _Listener, _DataSource, _FormSource> {
  @override
  String get tag => NearbyString.customerUpdateTag;

  @override
  _Properties propertiesBuilder() => _Properties();

  @override
  _Listener listenerBuilder() => _Listener();

  @override
  _DataSource dataSourceBuilder() => _DataSource();

  @override
  _FormSource formSourceBuilder() => _FormSource();

  @override
  void ready() async {
    super.ready();
    properties.ready();
  }
}

class _Properties {
  _FormSource get _formSource => Get.find<_FormSource>(tag: NearbyString.customerUpdateTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: NearbyString.customerUpdateTag);

  Task task = Task(NearbyString.updateTaskCode);

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
    Get.find<TaskHelper>().loaderPush(task);
  }
}
