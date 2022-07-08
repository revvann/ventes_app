// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/app/resources/views/contact/contact.dart';
import 'package:ventes/app/resources/views/contact_form/create/contact_person_fc.dart';
import 'package:ventes/app/resources/views/contact_form/update/contact_person_fu.dart';
import 'package:ventes/app/resources/views/product/product.dart';
import 'package:ventes/app/resources/views/product_form/create/product_fc.dart';
import 'package:ventes/app/resources/views/product_form/update/product_fu.dart';
import 'package:ventes/app/resources/views/prospect_assign/prospect_assign.dart';
import 'package:ventes/app/resources/views/prospect_competitor/prospect_competitor.dart';
import 'package:ventes/app/resources/views/prospect_competitor_form/create/prospect_competitor_fc.dart';
import 'package:ventes/app/resources/views/prospect_competitor_form/update/prospect_competitor_fu.dart';
import 'package:ventes/app/resources/views/prospect_dashboard/prospect_dashboard.dart';
import 'package:ventes/app/resources/views/prospect_activity/prospect_activity.dart';
import 'package:ventes/app/resources/views/prospect_activity_form/create/prospect_activity_fc.dart';
import 'package:ventes/app/resources/views/prospect_activity_form/update/prospect_activity_fu.dart';
import 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';
import 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';
import 'package:ventes/app/states/controllers/contact_person_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/contact_person_fu_state_controller.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/app/states/controllers/product_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/product_fu_state_controller.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_assign_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_competitor_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_competitor_fu_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_competitor_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_dashboard_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_activity_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_activity_fu_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_activity_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_fu_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/app/resources/views/prospect/prospect.dart';
import 'package:ventes/core/routing/page_route.dart';
import 'package:ventes/core/view/view_navigator.dart';

class ProspectNavigator extends ViewNavigator {
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
        ProspectActivityView.route: (args) => ViewRoute(
              page: () => ProspectActivityView(args!['prospect']),
              binding: BindingsBuilder(() {
                Get.put(ProspectActivityStateController());
              }),
            ),
        ProspectActivityFormCreateView.route: (args) => ViewRoute(
              page: () => ProspectActivityFormCreateView(args!['prospect']),
              binding: BindingsBuilder(() {
                Get.put(ProspectActivityFormCreateStateController());
              }),
            ),
        ProspectActivityFormUpdateView.route: (args) => ViewRoute(
              page: () => ProspectActivityFormUpdateView(args!['prospectactivity']),
              binding: BindingsBuilder(() {
                Get.put(ProspectActivityFormUpdateStateController());
              }),
            ),
        ContactPersonView.route: (args) => ViewRoute(
              page: () => ContactPersonView(args!['customer']),
              binding: BindingsBuilder(() {
                Get.put(ContactPersonStateController());
              }),
            ),
        ContactPersonFormCreateView.route: (args) => ViewRoute(
              page: () => ContactPersonFormCreateView(args!['customer']),
              binding: BindingsBuilder(() {
                Get.put(ContactPersonFormCreateStateController());
              }),
            ),
        ContactPersonFormUpdateView.route: (args) => ViewRoute(
              page: () => ContactPersonFormUpdateView(args!['contact']),
              binding: BindingsBuilder(() {
                Get.put(ContactPersonFormUpdateStateController());
              }),
            ),
        ProductView.route: (args) => ViewRoute(
              page: () => ProductView(args!['prospect']),
              binding: BindingsBuilder(() {
                Get.put(ProductStateController());
              }),
            ),
        ProductFormUpdateView.route: (args) => ViewRoute(
              page: () => ProductFormUpdateView(args!['product']),
              binding: BindingsBuilder(() {
                Get.put(ProductFormUpdateStateController());
              }),
            ),
        ProductFormCreateView.route: (args) => ViewRoute(
              page: () => ProductFormCreateView(args!['prospect']),
              binding: BindingsBuilder(() {
                Get.put(ProductFormCreateStateController());
              }),
            ),
        ProspectAssignView.route: (args) => ViewRoute(
              page: () => ProspectAssignView(args!['prospect']),
              binding: BindingsBuilder(() {
                Get.put(ProspectAssignStateController());
              }),
            ),
        ProspectDashboardView.route: (args) => ViewRoute(
              page: () => ProspectDashboardView(args!['prospect']),
              binding: BindingsBuilder(() {
                Get.put(ProspectDashboardStateController());
              }),
            ),
        ProspectCompetitorView.route: (args) => ViewRoute(
              page: () => ProspectCompetitorView(args!['prospect']),
              binding: BindingsBuilder(() {
                Get.put(ProspectCompetitorStateController());
              }),
            ),
        ProspectCompetitorFormCreateView.route: (args) => ViewRoute(
              page: () => ProspectCompetitorFormCreateView(args!['prospect']),
              binding: BindingsBuilder(() {
                Get.put(ProspectCompetitorFormCreateStateController());
              }),
            ),
        ProspectCompetitorFormUpdateView.route: (args) => ViewRoute(
              page: () => ProspectCompetitorFormUpdateView(args!['competitor']),
              binding: BindingsBuilder(() {
                Get.put(ProspectCompetitorFormUpdateStateController());
              }),
            ),
      };
}
