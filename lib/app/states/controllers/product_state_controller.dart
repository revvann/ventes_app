// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/resources/views/product_form/update/product_fu.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/prospect_product_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/product_presenter.dart';

part 'package:ventes/app/states/data_sources/product_data_source.dart';
part 'package:ventes/app/states/listeners/product_listener.dart';

class ProductStateController extends RegularStateController<_Properties, _Listener, _DataSource> {
  @override
  String get tag => ProspectString.productTag;

  @override
  _Properties propertiesBuilder() => _Properties();

  @override
  _Listener listenerBuilder() => _Listener();

  @override
  _DataSource dataSourceBuilder() => _DataSource();

  @override
  void init() {
    super.init();
    properties.searchTEC.addListener(properties.onSearchChanged);
  }

  @override
  void close() {
    super.close();
    properties.debounce?.cancel();
    for (var element in properties.popupControllers) {
      Get.delete<PopupMenuController>(tag: element);
    }
  }
}

class _Properties {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.productTag);

  Set<String> popupControllers = {};

  TextEditingController searchTEC = TextEditingController();
  String lastSearch = "";
  Timer? debounce;
  final isLoading = false.obs;

  late int prospectid;

  void refresh() {
    _dataSource.fetchData(prospectid);
    Get.find<TaskHelper>().loaderPush(ProspectString.productTaskCode);
  }

  void searchProducts() {
    isLoading.value = true;
    _dataSource.fetchProducts(prospectid, lastSearch);
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
}
