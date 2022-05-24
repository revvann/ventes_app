// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/network/services/bp_customer_service.dart';
import 'package:ventes/app/network/services/prospect_service.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';
import 'package:ventes/app/states/controllers/prospect_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/app/resources/views/prospect/prospect.dart';
import 'package:ventes/core/page_route.dart';
import 'package:ventes/core/view_navigator.dart';

class ProspectNavigator extends ViewNavigator {
  static const id = 4;
  ProspectNavigator({required GlobalKey<NavigatorState> navigatorKey}) : super(navigatorKey: navigatorKey);

  @override
  String get initialRoute => ProspectView.route;

  @override
  Map<String, ViewRoute Function(Map args)> get routes => {
        ProspectView.route: (args) => ViewRoute(
              page: () => ProspectView(),
              binding: BindingsBuilder(() {
                Get.put(ProspectService());
                Get.put(TypeService());
                Get.put(ProspectStateController());
              }),
            ),
        ProspectFormCreateView.route: (args) => ViewRoute(
              page: () => ProspectFormCreateView(),
              binding: BindingsBuilder(() {
                Get.put(ProspectService());
                Get.put(UserService());
                Get.put(TypeService());
                Get.put(BpCustomerService());
                Get.put(ProspectFormCreateStateController());
              }),
            ),
      };
}