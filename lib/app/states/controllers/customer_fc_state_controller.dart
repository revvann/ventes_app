// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/presenters/customer_fc_presenter.dart';
import 'package:ventes/app/states/controllers/form_state_controller.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/form_sources/update_form_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:ventes/app/resources/widgets/search_list.dart';

part 'package:ventes/app/states/form_sources/customer_fc_form_source.dart';
part 'package:ventes/app/states/data_sources/customer_fc_data_source.dart';
part 'package:ventes/app/states/listeners/customer_fc_listener.dart';
part 'package:ventes/app/states/form_validators/customer_fc_validator.dart';

class CustomerFormCreateStateController extends FormStateController<_Properties, _Listener, _DataSource, _FormSource> {
  @override
  String get tag => NearbyString.customerCreateTag;

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

    if (properties.latitude != null && properties.longitude != null) {
      properties.refresh();
    }
  }
}

class _Properties {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: NearbyString.customerCreateTag);

  final double defaultZoom = 20;
  final Completer<GoogleMapController> mapsController = Completer();

  final rxLatitude = Rx<double?>(null);
  final rxLongitude = Rx<double?>(null);
  int? cstmid;

  double? get latitude => rxLatitude.value;
  set latitude(double? value) => rxLatitude.value = value;

  double? get longitude => rxLongitude.value;
  set longitude(double? value) => rxLongitude.value = value;

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

  void deployCustomers(List<BpCustomer> data) {
    List<Marker> markersList = [markers.first];
    for (var element in data) {
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

  void fetchPlacesIds() {
    _dataSource.fetchPlacesIds(_dataSource.getSubdistrictName()!);
    Get.find<TaskHelper>().loaderPush(NearbyString.createTaskCode);
  }

  void refresh() async {
    _dataSource.fetchData(latitude!, longitude!, cstmid);

    LatLng pos = LatLng(latitude!, longitude!);
    GoogleMapController controller = await mapsController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(pos),
    );
    markerLatLng = pos;
    Get.find<TaskHelper>().loaderPush(NearbyString.createTaskCode);
  }
}
