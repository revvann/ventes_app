// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/product_fu_data_source.dart';
import 'package:ventes/app/states/form_sources/product_fu_form_source.dart';
import 'package:ventes/app/states/listeners/product_fu_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProductFormUpdateStateController extends RegularStateController {
  ProductFormUpdateProperties properties = Get.put(ProductFormUpdateProperties());
  ProductFormUpdateListener listener = Get.put(ProductFormUpdateListener());
  ProductFormUpdateFormSource formSource = Get.put(ProductFormUpdateFormSource());
  ProductFormUpdateDataSource dataSource = Get.put(ProductFormUpdateDataSource());

  @override
  void onClose() {
    Get.delete<ProductFormUpdateProperties>();
    Get.delete<ProductFormUpdateListener>();
    Get.delete<ProductFormUpdateFormSource>();
    Get.delete<ProductFormUpdateDataSource>();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    formSource.init();
    dataSource.init();
  }

  @override
  void onReady() {
    super.onReady();
    properties.refresh();
  }
}

class ProductFormUpdateProperties {
  ProductFormUpdateDataSource get _dataSource => Get.find<ProductFormUpdateDataSource>();
  late int productid;

  void refresh() {
    _dataSource.fetchData(productid);
    Get.find<TaskHelper>().loaderPush(ProspectString.formUpdateProductTaskCode);
  }
}
