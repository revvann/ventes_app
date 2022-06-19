import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/customer_fc_typedef.dart';

class CustomerFormCreateProperty extends StateProperty {
  DataSource get _dataSource => Get.find<DataSource>(tag: NearbyString.customerCreateTag);

  Task task = Task(NearbyString.createTaskCode);

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
    Get.find<TaskHelper>().loaderPush(task);
  }

  void refresh() async {
    _dataSource.fetchData(latitude!, longitude!, cstmid);

    LatLng pos = LatLng(latitude!, longitude!);
    GoogleMapController controller = await mapsController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(pos),
    );
    markerLatLng = pos;
    Get.find<TaskHelper>().loaderPush(task);
  }

  @override
  void ready() {
    super.ready();
    if (latitude != null && longitude != null) {
      refresh();
    }
  }
}
