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
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

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

  void onCameraMoveEnd() async {
    property.cameraMoveType = CameraMoveType.dragged;
    String? address = await dataSource.fetchAddress(property.markers.first.position.latitude, property.markers.first.position.longitude);
    List<Marker> markersList = property.markers.toList();
    markersList[0] = markersList[0].copyWith(
      infoWindowParam: InfoWindow(title: address ?? "Unknown"),
    );
    property.markers = Set.from(markersList);
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
          id: Views.nearby.index,
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
          id: Views.nearby.index,
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
            dataSource.deleteHandler.fetcher.run(bpcustomer.sbcid!);
            Get.find<TaskHelper>().loaderPush(property.task);
          }
        },
      ),
    );
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
