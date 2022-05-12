// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/customer_fc_data_source.dart';
import 'package:ventes/app/states/form_sources/customer_fc_form_source.dart';
import 'package:ventes/app/states/listeners/customer_fc_listener.dart';
import 'package:ventes/constants/strings/nearby_string.dart';

class CustomerFormCreateStateController extends RegularStateController {
  CustomerFormCreateProperties properties = Get.put(CustomerFormCreateProperties());
  CustomerFormCreateListener listener = Get.put(CustomerFormCreateListener());
  CustomerFormCreateFormSource formSource = Get.put(CustomerFormCreateFormSource());

  @override
  onInit() {
    super.onInit();
    properties.dataSource.fetchDataContract = listener;
    properties.dataSource.createContract = listener;
    formSource.init();
  }

  @override
  void onReady() async {
    super.onReady();

    if (properties.latitude != null && properties.longitude != null) {
      LatLng pos = LatLng(properties.latitude!, properties.longitude!);
      GoogleMapController controller = await properties.mapsController.future;
      controller.animateCamera(
        CameraUpdate.newLatLng(pos),
      );
      properties.markerLatLng = pos;
    }

    properties.dataSource.fetchData();
    Loader().show();
  }

  @override
  void onClose() {
    Get.delete<CustomerFormCreateProperties>();
    Get.delete<CustomerFormCreateListener>();
    Get.delete<CustomerFormCreateFormSource>();
    super.onClose();
  }
}

class CustomerFormCreateProperties {
  CustomerFormCreateDataSource dataSource = CustomerFormCreateDataSource();

  final double defaultZoom = 14.5;
  final Completer<GoogleMapController> mapsController = Completer();

  final rxLatitude = Rx<double?>(null);
  final rxLongitude = Rx<double?>(null);

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
