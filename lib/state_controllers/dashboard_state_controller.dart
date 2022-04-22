import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/state_controllers/bottom_navigation_state_controller.dart';

class DashboardStateController extends GetxController {
  final bottomNavigation = Get.find<BottomNavigationStateController>();
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
}
