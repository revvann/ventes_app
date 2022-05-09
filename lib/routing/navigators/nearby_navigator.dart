// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/network/services/bp_customer_service.dart';
import 'package:ventes/app/network/services/gmaps_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/routing/routes/regular_get_page.dart';
import 'package:ventes/state/controllers/nearby_state_controller.dart';
import 'package:ventes/app/resources/views/nearby.dart';

class NearbyNavigator extends StatelessWidget {
  static const id = 2;
  NearbyNavigator({required this.navigatorKey});
  GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: NearbyView.route,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == NearbyView.route) {
          return RegularGetRoute(
            page: () => NearbyView(),
            bindings: [
              BindingsBuilder(() {
                Get.lazyPut(() => GmapsService());
                Get.lazyPut(() => UserService());
                Get.lazyPut(() => BpCustomerService());
                Get.lazyPut(() => NearbyStateController());
              })
            ],
          );
        }
      },
    );
  }
}
