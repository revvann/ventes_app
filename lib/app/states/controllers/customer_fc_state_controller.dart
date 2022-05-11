// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/customer_fc_data_source.dart';
import 'package:ventes/app/states/form_sources/customer_fc_form_source.dart';
import 'package:ventes/app/states/listeners/customer_fc_listener.dart';

class CustomerFormCreateStateController extends RegularStateController {
  CustomerFormCreateProperties properties = Get.put(CustomerFormCreateProperties());
  CustomerFormCreateListener listener = Get.put(CustomerFormCreateListener());
  CustomerFormCreateFormSource formSource = Get.put(CustomerFormCreateFormSource());

  @override
  onInit() {
    super.onInit();
    formSource.init();
  }

  @override
  void onClose() {
    Get.delete<CustomerFormCreateProperties>();
    Get.delete<CustomerFormCreateListener>();
    Get.delete<CustomerFormCreateFormSource>();
    super.onClose();
  }
}

class CustomerFormCreateProperties {
  CustomerFormCreateDataSource dataSource = CustomerFormCreateDataSource();
}
