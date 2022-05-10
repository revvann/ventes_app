import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/state/controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/app/state/controllers/regular_state_controller.dart';

class DashboardStateController extends RegularStateController {
  @override
  bool get isFixedBody => false;

  final bottomNavigation = Get.find<BottomNavigationStateController>();
}
