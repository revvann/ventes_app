// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/views/prospect_detail/prospect_detail.dart';
import 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';
import 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_fu_state_controller.dart';
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
  Map<String, ViewRoute Function(Map? args)> get routes => {
        ProspectView.route: (args) => ViewRoute(
              page: () => ProspectView(),
              binding: BindingsBuilder(() {
                Get.put(ProspectStateController());
              }),
            ),
        ProspectFormCreateView.route: (args) => ViewRoute(
              page: () => ProspectFormCreateView(),
              binding: BindingsBuilder(() {
                Get.put(ProspectFormCreateStateController());
              }),
            ),
        ProspectFormUpdateView.route: (args) => ViewRoute(
              page: () => ProspectFormUpdateView(args!['prospect']),
              binding: BindingsBuilder(() {
                Get.put(ProspectFormUpdateStateController());
              }),
            ),
        ProspectDetailView.route: (args) => ViewRoute(
              page: () => ProspectDetailView(args!['prospect']),
              binding: BindingsBuilder(() {
                Get.put(ProspectDetailStateController());
              }),
            ),
      };
}
