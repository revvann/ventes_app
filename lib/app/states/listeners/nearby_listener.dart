// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';

class NearbyListener implements FetchDataContract {
  NearbyProperties get _properties => Get.find<NearbyProperties>();

  void onMapControllerCreated(GoogleMapController controller) {
    if (!_properties.mapsController.isCompleted) {
      _properties.mapsController.complete(controller);
    }
  }

  void onCameraMoved(position) {
    _properties.markerLatLng = position.target;
  }

  void onCustomerSelected(BpCustomer customer) {
    LatLng latLng = LatLng(customer.sbccstm!.cstmlatitude!, customer.sbccstm!.cstmlongitude!);
    _properties.mapsController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
    });
  }

  void onAddDataClick() {
    Get.toNamed(
      CustomerFormCreateView.route,
      id: NearbyNavigator.id,
      arguments: {
        'latitude': _properties.markers.first.position.latitude,
        'longitude': _properties.markers.first.position.longitude,
      },
    );
  }

  @override
  onLoadError(String message) {
    Get.close(1);
    ErrorAlert(NearbyString.fetchError).show();
  }

  @override
  onLoadFailed(String message) {
    Get.close(1);
    FailedAlert(NearbyString.fetchFailed).show();
  }

  @override
  onLoadSuccess(Map data) {
    if (data['location'] != null) {
      _properties.dataSource.locationDetailLoaded(data['location'] as Map<String, dynamic>);
    }

    if (data['customers'] != null) {
      _properties.deployCustomers(data['customers']);
    }
    Get.close(1);
  }
}
