import 'package:get/get.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:ventes/app/state/controllers/customer_fc_state_controller.dart';

class CustomerFormCreateListener {
  CustomerFormCreateProperties get _properties => Get.find<CustomerFormCreateProperties>();

  void goBack() {
    Get.back(id: NearbyNavigator.id);
  }
}
