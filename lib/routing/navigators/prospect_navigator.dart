// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/views/contact/contact.dart';
import 'package:ventes/app/resources/views/contact_form/create/contact_person_fc.dart';
import 'package:ventes/app/resources/views/contact_form/update/contact_person_fu.dart';
import 'package:ventes/app/resources/views/product/product.dart';
import 'package:ventes/app/resources/views/product_form/update/product_fu.dart';
import 'package:ventes/app/resources/views/prospect_detail/prospect_detail.dart';
import 'package:ventes/app/resources/views/prospect_detail_form/create/prospect_detail_fc.dart';
import 'package:ventes/app/resources/views/prospect_detail_form/update/prospect_detail_fu.dart';
import 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';
import 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';
import 'package:ventes/app/states/controllers/contact_person_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/contact_person_fu_state_controller.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/app/states/controllers/product_fu_state_controller.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_detail_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_detail_fu_state_controller.dart';
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
        ProspectDetailFormCreateView.route: (args) => ViewRoute(
              page: () => ProspectDetailFormCreateView(args!['prospect']),
              binding: BindingsBuilder(() {
                Get.put(ProspectDetailFormCreateStateController());
              }),
            ),
        ProspectDetailFormUpdateView.route: (args) => ViewRoute(
              page: () => ProspectDetailFormUpdateView(args!['prospectdetail']),
              binding: BindingsBuilder(() {
                Get.put(ProspectDetailFormUpdateStateController());
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
      };
}
