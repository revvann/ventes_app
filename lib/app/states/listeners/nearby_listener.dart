// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';
import 'package:ventes/app/resources/views/customer_form/update/customer_fu.dart';
import 'package:ventes/app/states/typedefs/nearby_typedef.dart';
import 'package:ventes/app/states/properties/nearby_property.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';

class NearbyListener extends StateListener {
  Property get _property => Get.find<Property>(tag: NearbyString.nearbyTag);
  DataSource get _dataSource => Get.find<DataSource>(tag: NearbyString.nearbyTag);

  void onMapControllerCreated(GoogleMapController controller) {
    if (!_property.mapsController.isCompleted) {
      _property.mapsController.complete(controller);
    }
  }

  void onCameraMoved(CameraPosition position) {
    _property.markerLatLng = position.target;
    if (_property.cameraMoveType == CameraMoveType.dragged) {
      _property.selectedCustomer = _dataSource.customers.where((customer) {
        LatLng customerPos = LatLng(customer.cstmlatitude ?? 0, customer.cstmlongitude ?? 0);
        return calculateDistance(customerPos, position.target) < 0.5;
      }).toList();
    }
  }

  void onCameraMoveEnd() {
    _property.cameraMoveType = CameraMoveType.dragged;
  }

  void onCustomerSelected(Customer customer) {
    _property.cameraMoveType = CameraMoveType.controller;
    _property.selectedCustomer = [customer];
    LatLng latLng = LatLng(customer.cstmlatitude!, customer.cstmlongitude!);
    _property.mapsController.future.then((controller) async {
      controller.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void onAddDataClick() async {
    Get.find<TaskHelper>().loaderPush(_property.task);
    getCurrentPosition().then((position) {
      Get.find<TaskHelper>().loaderPop(_property.task.name);
      double radius = calculateDistance(_property.markers.first.position, LatLng(position.latitude, position.longitude));

      int? cstmid;
      if (_property.selectedCustomer.isNotEmpty) {
        cstmid = _property.selectedCustomer.first.cstmid;
      }

      if (radius < 100) {
        Get.toNamed(
          CustomerFormCreateView.route,
          id: NearbyNavigator.id,
          arguments: {
            'latitude': _property.markers.first.position.latitude,
            'longitude': _property.markers.first.position.longitude,
            'cstmid': cstmid,
          },
        );
      } else {
        Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: NearbyString.customerOuttaRange));
      }
    });
  }

  void onEditDataClick() async {
    Get.find<TaskHelper>().loaderPush(_property.task);
    getCurrentPosition().then((position) async {
      Get.find<TaskHelper>().loaderPop(_property.task.name);

      Customer customer = _property.selectedCustomer.first;
      BpCustomer bpcustomer = _dataSource.bpCustomers.firstWhere((element) => element.sbccstmid == customer.cstmid);

      double radius = calculateDistance(_property.markers.first.position, LatLng(position.latitude, position.longitude));
      if (radius < 100) {
        Get.toNamed(
          CustomerFormUpdateView.route,
          id: NearbyNavigator.id,
          arguments: {
            'bpcustomer': bpcustomer.sbcid,
          },
        );
      } else {
        await Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: NearbyString.customerOuttaRange));
      }
    });
  }

  void onDeleteDataClick() {
    Get.find<TaskHelper>().confirmPush(
      _property.task.copyWith(
        message: NearbyString.deleteCustomerConfirm,
        onFinished: (res) {
          if (res) {
            Customer customer = _property.selectedCustomer.first;
            BpCustomer bpcustomer = _dataSource.bpCustomers.firstWhere((element) => element.sbccstmid == customer.cstmid);
            _dataSource.deleteData(bpcustomer.sbcid!);
            Get.find<TaskHelper>().loaderPush(_property.task);
          }
        },
      ),
    );
  }

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onDeleteFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onDeleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(_property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<NearbyStateController>().refreshStates();
        }));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onDeleteError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  Future onReady() async {
    _property.refresh();
  }
}
