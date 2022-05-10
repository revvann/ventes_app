// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/state/controllers/regular_state_controller.dart';
import 'package:ventes/state/form_sources/customer_fc_form_source.dart';
import 'package:ventes/state/listeners/customer_fc_listener.dart';

class CustomerFormCreateStateController extends RegularStateController {
  CustomerFormCreateProperties properties = Get.put(CustomerFormCreateProperties());
  CustomerFormCreateListener listener = Get.put(CustomerFormCreateListener());
  CustomerFormCreateFormSource formSource = Get.put(CustomerFormCreateFormSource());

  @override
  void onClose() {
    Get.delete<CustomerFormCreateProperties>();
    Get.delete<CustomerFormCreateListener>();
    Get.delete<CustomerFormCreateFormSource>();
    super.onClose();
  }
}

class CustomerFormCreateProperties {}
