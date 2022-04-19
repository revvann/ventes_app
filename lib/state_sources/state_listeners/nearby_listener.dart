import 'package:get/get.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/state_controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/state_controllers/nearby_state_controller.dart';

class NearbyListener {
  NearbyListener(this.$);
  NearbyStateController $;

  void backToDashboard() {
    BottomNavigationStateController $bottomNavigation = Get.find<BottomNavigationStateController>();
    $bottomNavigation.currentIndex = Views.dashboard;
  }
}
