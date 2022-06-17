// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/views/customer_form/create/customer_fc.dart';
import 'package:ventes/app/resources/views/customer_form/update/customer_fu.dart';
import 'package:ventes/app/states/controllers/customer_fu_state_controller.dart';
import 'package:ventes/core/routing/page_route.dart';
import 'package:ventes/app/states/controllers/customer_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/app/resources/views/nearby/nearby.dart';
import 'package:ventes/core/view/view_navigator.dart';

class NearbyNavigator extends ViewNavigator {
  static const id = 2;
  NearbyNavigator({required GlobalKey<NavigatorState> navigatorKey}) : super(navigatorKey: navigatorKey);

  @override
  String get initialRoute => NearbyView.route;

  @override
  Map<String, ViewRoute Function(Map? args)> get routes => {
        NearbyView.route: (args) => ViewRoute(
              page: () => NearbyView(),
              bindings: [
                BindingsBuilder(() {
                  Get.lazyPut(() => NearbyStateController());
                })
              ],
            ),
        CustomerFormCreateView.route: (args) => ViewRoute(
              page: () => CustomerFormCreateView(
                latitude: args?['latitude'],
                longitude: args?['longitude'],
                cstmid: args?['cstmid'],
              ),
              bindings: [
                BindingsBuilder(() {
                  Get.lazyPut(() => CustomerFormCreateStateController());
                })
              ],
            ),
        CustomerFormUpdateView.route: (args) => ViewRoute(
              page: () => CustomerFormUpdateView(args!['bpcustomer']),
              bindings: [
                BindingsBuilder(() {
                  Get.lazyPut(() => CustomerFormUpdateStateController());
                })
              ],
            ),
      };
}
