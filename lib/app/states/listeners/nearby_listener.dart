// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';
import 'package:ventes/app/resources/views/customer_form/update/customer_fu.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/app/states/data_sources/nearby_data_source.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';

class NearbyListener {
  NearbyProperties get _properties => Get.find<NearbyProperties>();
  NearbyDataSource get _dataSource => Get.find<NearbyDataSource>();

  void onMapControllerCreated(GoogleMapController controller) {
    if (!_properties.mapsController.isCompleted) {
      _properties.mapsController.complete(controller);
    }
  }

  void onCameraMoved(CameraPosition position) {
    _properties.markerLatLng = position.target;
    if (_properties.cameraMoveType == CameraMoveType.dragged) {
      _properties.selectedCustomer = _dataSource.customers.where((customer) {
        LatLng customerPos = LatLng(customer.cstmlatitude ?? 0, customer.cstmlongitude ?? 0);
        return calculateDistance(customerPos, position.target) < 0.5;
      }).toList();
    }
  }

  void onCameraMoveEnd() {
    _properties.cameraMoveType = CameraMoveType.dragged;
  }

  void onCustomerSelected(Customer customer) {
    _properties.cameraMoveType = CameraMoveType.controller;
    _properties.selectedCustomer = [customer];
    LatLng latLng = LatLng(customer.cstmlatitude!, customer.cstmlongitude!);
    _properties.mapsController.future.then((controller) async {
      controller.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void onAddDataClick() async {
    Get.find<TaskHelper>().loaderPush(NearbyString.taskCode);
    getCurrentPosition().then((position) {
      Get.find<TaskHelper>().loaderPop(NearbyString.taskCode);
      double radius = calculateDistance(_properties.markers.first.position, LatLng(position.latitude, position.longitude));

      int? cstmid;
      if (_properties.selectedCustomer.isNotEmpty) {
        cstmid = _properties.selectedCustomer.first.cstmid;
      }

      if (radius < 100) {
        Get.toNamed(
          CustomerFormCreateView.route,
          id: NearbyNavigator.id,
          arguments: {
            'latitude': _properties.markers.first.position.latitude,
            'longitude': _properties.markers.first.position.longitude,
            'cstmid': cstmid,
          },
        );
      } else {
        Get.find<TaskHelper>().failedPush(NearbyString.taskCode, NearbyString.customerOuttaRange);
      }
    });
  }

  Future onRefresh() async {
    _properties.refresh();
  }

  void onEditDataClick() async {
    Get.find<TaskHelper>().loaderPush(NearbyString.taskCode);
    getCurrentPosition().then((position) async {
      Get.find<TaskHelper>().loaderPop(NearbyString.taskCode);

      Customer customer = _properties.selectedCustomer.first;
      BpCustomer bpcustomer = _dataSource.bpCustomers.firstWhere((element) => element.sbccstmid == customer.cstmid);

      double radius = calculateDistance(_properties.markers.first.position, LatLng(position.latitude, position.longitude));
      if (radius < 100) {
        Get.toNamed(
          CustomerFormUpdateView.route,
          id: NearbyNavigator.id,
          arguments: {
            'bpcustomer': bpcustomer.sbcid,
          },
        );
      } else {
        await Get.find<TaskHelper>().failedPush(NearbyString.taskCode, NearbyString.customerOuttaRange);
      }
    });
  }

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(NearbyString.taskCode, message);
    Get.find<TaskHelper>().loaderPop(NearbyString.taskCode);
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(NearbyString.taskCode, message);
    Get.find<TaskHelper>().loaderPop(NearbyString.taskCode);
  }
}
