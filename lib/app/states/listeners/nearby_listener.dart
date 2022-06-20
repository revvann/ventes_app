// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';
import 'package:ventes/app/resources/views/customer_form/update/customer_fu.dart';
import 'package:ventes/app/states/properties/nearby_property.dart';
import 'package:ventes/app/states/typedefs/nearby_typedef.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';

class NearbyListener extends StateListener with ListenerMixin {
  void onMapControllerCreated(GoogleMapController controller) {
    if (!property.mapsController.isCompleted) {
      property.mapsController.complete(controller);
    }
  }

  void onCameraMoved(CameraPosition position) {
    property.markerLatLng = position.target;
    if (property.cameraMoveType == CameraMoveType.dragged) {
      property.selectedCustomer = dataSource.customers.where((customer) {
        LatLng customerPos = LatLng(customer.cstmlatitude ?? 0, customer.cstmlongitude ?? 0);
        return calculateDistance(customerPos, position.target) < 0.5;
      }).toList();
    }
  }

  void onCameraMoveEnd() {
    property.cameraMoveType = CameraMoveType.dragged;
  }

  void onCustomerSelected(Customer customer) {
    property.cameraMoveType = CameraMoveType.controller;
    property.selectedCustomer = [customer];
    LatLng latLng = LatLng(customer.cstmlatitude!, customer.cstmlongitude!);
    property.mapsController.future.then((controller) async {
      controller.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void onAddDataClick() async {
    Get.find<TaskHelper>().loaderPush(property.task);
    getCurrentPosition().then((position) {
      Get.find<TaskHelper>().loaderPop(property.task.name);
      double radius = calculateDistance(property.markers.first.position, LatLng(position.latitude, position.longitude));

      int? cstmid;
      if (property.selectedCustomer.isNotEmpty) {
        cstmid = property.selectedCustomer.first.cstmid;
      }

      if (radius < 100) {
        Get.toNamed(
          CustomerFormCreateView.route,
          id: NearbyNavigator.id,
          arguments: {
            'latitude': property.markers.first.position.latitude,
            'longitude': property.markers.first.position.longitude,
            'cstmid': cstmid,
          },
        );
      } else {
        Get.find<TaskHelper>().failedPush(property.task.copyWith(message: NearbyString.customerOuttaRange));
      }
    });
  }

  void onEditDataClick() async {
    Get.find<TaskHelper>().loaderPush(property.task);
    getCurrentPosition().then((position) async {
      Get.find<TaskHelper>().loaderPop(property.task.name);
      Customer customer = property.selectedCustomer.first;
      BpCustomer bpcustomer = dataSource.bpCustomers.firstWhere((element) => element.sbccstmid == customer.cstmid);

      double radius = calculateDistance(property.markers.first.position, LatLng(position.latitude, position.longitude));
      if (radius < 100) {
        Get.toNamed(
          CustomerFormUpdateView.route,
          id: NearbyNavigator.id,
          arguments: {
            'bpcustomer': bpcustomer.sbcid,
          },
        );
      } else {
        await Get.find<TaskHelper>().failedPush(property.task.copyWith(message: NearbyString.customerOuttaRange));
      }
    });
  }

  void onDeleteDataClick() {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith(
        message: NearbyString.deleteCustomerConfirm,
        onFinished: (res) {
          if (res) {
            Customer customer = property.selectedCustomer.first;
            BpCustomer bpcustomer = dataSource.bpCustomers.firstWhere((element) => element.sbccstmid == customer.cstmid);
            dataSource.deleteData(bpcustomer.sbcid!);
            Get.find<TaskHelper>().loaderPush(property.task);
          }
        },
      ),
    );
  }

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onDeleteFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onDeleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<NearbyStateController>().refreshStates();
        }));
  }

  void onDeleteError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onComplete() => Get.find<TaskHelper>().loaderPop(property.task.name);
  @override
  Future onReady() async {
    property.refresh();
  }
}
