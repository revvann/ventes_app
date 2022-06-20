import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/product_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProductProperty extends StateProperty with PropertyMixin {
  Task task = Task(ProspectString.productTaskCode);

  Set<String> popupControllers = {};

  TextEditingController searchTEC = TextEditingController();
  String lastSearch = "";
  Timer? debounce;
  final isLoading = false.obs;

  late int prospectid;

  void refresh() {
    dataSource.fetchData(prospectid);
    Get.find<TaskHelper>().loaderPush(task);
  }

  void searchProducts() {
    isLoading.value = true;
    dataSource.fetchProducts(prospectid, lastSearch);
  }

  void onSearchChanged() {
    if (lastSearch != searchTEC.text) {
      lastSearch = searchTEC.text;
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), searchProducts);
    }
  }

  PopupMenuController createPopupController([int id = 0]) {
    String tag = "popup_$id";
    popupControllers.add(tag);
    return Get.put(PopupMenuController(), tag: tag);
  }

  String priceShort(double price) {
    if (price < 1e3) {
      return price.toStringAsFixed(0);
    } else if (price < 1e6) {
      return "${(price ~/ 1e3)} K";
    } else if (price < 1e9) {
      return "${(price ~/ 1e6)} M";
    } else {
      return "${(price ~/ 1e9)} B";
    }
  }

  @override
  void ready() {
    super.ready();
    searchTEC.addListener(onSearchChanged);
  }

  @override
  void close() {
    super.close();
    debounce?.cancel();
    for (var element in popupControllers) {
      Get.delete<PopupMenuController>(tag: element);
    }
  }
}
