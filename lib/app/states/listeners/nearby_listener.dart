// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';

class NearbyListener {
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

  void onAddDataClick() async {
    Loader().show();
    getCurrentPosition().then((position) {
      Get.close(1);
      double radius = calculateDistance(_properties.markers.first.position, LatLng(position.latitude, position.longitude));
      if (radius < 100) {
        Get.toNamed(
          CustomerFormCreateView.route,
          id: NearbyNavigator.id,
          arguments: {
            'latitude': _properties.markers.first.position.latitude,
            'longitude': _properties.markers.first.position.longitude,
          },
        );
      } else {
        FailedAlert(NearbyString.customerOuttaRange).show();
      }
    });
  }

  void onLoadDataError() {
    Get.close(1);
    ErrorAlert(NearbyString.fetchError).show();
  }

  void onLoadDataFailed() {
    Get.close(1);
    FailedAlert(NearbyString.fetchFailed).show();
  }
}
