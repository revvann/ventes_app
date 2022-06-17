// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/states/controllers/nearby_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: NearbyString.nearbyTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: NearbyString.nearbyTag);

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
    Get.find<TaskHelper>().loaderPush(_properties.task);
    getCurrentPosition().then((position) {
      Get.find<TaskHelper>().loaderPop(_properties.task.name);
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
        Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: NearbyString.customerOuttaRange));
      }
    });
  }

  void onEditDataClick() async {
    Get.find<TaskHelper>().loaderPush(_properties.task);
    getCurrentPosition().then((position) async {
      Get.find<TaskHelper>().loaderPop(_properties.task.name);

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
        await Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: NearbyString.customerOuttaRange));
      }
    });
  }

  void onDeleteDataClick() {
    Customer customer = _properties.selectedCustomer.first;
    BpCustomer bpcustomer = _dataSource.bpCustomers.firstWhere((element) => element.sbccstmid == customer.cstmid);
    _dataSource.deleteData(bpcustomer.sbcid!);
    Get.find<TaskHelper>().loaderPush(_properties.task);
  }

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onDeleteFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onDeleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(_properties.task.copyWith(
        message: message,
        onFinished: () {
          Get.find<NearbyStateController>().refreshStates();
        }));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onDeleteError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
