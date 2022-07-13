import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/app/resources/views/dashboard/dashboard.dart';
import 'package:ventes/app/resources/views/nearby/nearby.dart';
import 'package:ventes/app/resources/views/profile/profile.dart';
import 'package:ventes/app/resources/views/prospect/prospect.dart';
import 'package:ventes/app/resources/views/schedule/schedule.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/routing/route_pack.dart';
import 'package:ventes/utils/utils.dart';

class BottomNavigationStateController extends GetxController {
  BottomNavigationStateController() {
    _currentIndex = routePack.value.menu.obs;
  }

  late final Rx<Views> _currentIndex;
  Rx<RoutePack> get routePack => Get.find<Rx<RoutePack>>();

  final _navigatorKeys = {
    Views.dashboard: Get.nestedKey(Views.dashboard.index),
    Views.nearby: Get.nestedKey(Views.nearby.index),
    Views.schedule: Get.nestedKey(Views.schedule.index),
    Views.prospect: Get.nestedKey(Views.prospect.index),
    Views.profile: Get.nestedKey(Views.profile.index),
  };

  void selectTab(Views tabItem) {
    if (tabItem == _currentIndex.value) {
      Get.until((route) => route.isFirst);
    } else {
      _currentIndex.value = tabItem;
    }
  }

  Views get currentIndex => _currentIndex.value;
  set currentIndex(Views value) => _currentIndex.value = value;
  Map<Views, GlobalKey<NavigatorState>?> get navigatorKeys => _navigatorKeys;

  void goToRoutePack(RoutePack routePack) {
    currentIndex = routePack.menu;
    Get.toNamed(routePack.route, id: routePack.menu.index, arguments: routePack.arguments);
  }

  @override
  void onInit() {
    super.onInit();
    routePack.stream.listen(goToRoutePack);

    FirebaseMessaging.instance.onTokenRefresh.listen(Get.find<UserService>().setToken);
    FirebaseMessaging.instance.getToken().then(Get.find<UserService>().setToken);
    Utils.initSocket();
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      List<String> initialRoutes = [DashboardView.route, NearbyView.route, ScheduleView.route, ProspectView.route, ProfileView.route];
      if (!initialRoutes.contains(routePack.value.route)) {
        Get.toNamed(routePack.value.route, id: routePack.value.menu.index, arguments: routePack.value.arguments);
      }
    });
  }
}
