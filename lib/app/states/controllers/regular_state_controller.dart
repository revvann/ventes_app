import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';

abstract class RegularStateController<P, L extends RegularListener, D extends RegularDataSource> extends GetxController {
  final GlobalKey appBarKey = GlobalKey();
  bool get isFixedBody => true;

  final _minHeight = 0.0.obs;
  double get minHeight => _minHeight.value;
  set minHeight(double value) => _minHeight.value = value;

  P get properties => Get.find<P>();
  L get listener => Get.find<L>();
  D get dataSource => Get.find<D>();

  P propertiesBuilder() {
    throw UnimplementedError();
  }

  L listenerBuilder() {
    throw UnimplementedError();
  }

  D dataSourceBuilder() {
    throw UnimplementedError();
  }

  List<Function> get _builders => [
        propertiesBuilder,
        listenerBuilder,
        dataSourceBuilder,
      ];

  @mustCallSuper
  void init() {
    for (var builder in _builders) {
      try {
        Get.replace(builder());
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @mustCallSuper
  void ready() {
    if (isFixedBody) {
      RenderBox renderBox = appBarKey.currentContext?.findRenderObject() as RenderBox;
      double distraction = renderBox.size.height;
      _minHeight.value = Get.height - distraction;
    }
  }

  @mustCallSuper
  void close() {
    Get.delete<P>();
    Get.delete<L>();
    Get.delete<D>();
  }

  @override
  void onInit() {
    super.onInit();
    init();
    dataSource.init();
  }

  @override
  void onReady() {
    super.onReady();
    ready();
    listener.onRefresh();
  }

  @override
  void onClose() {
    close();
    super.onClose();
  }
}
