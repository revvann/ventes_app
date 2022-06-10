import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';

abstract class RegularStateController<P, L extends RegularListener, D extends RegularDataSource> extends GetxController {
  final GlobalKey appBarKey = GlobalKey();
  bool get isFixedBody => true;
  String get tag => "";

  final _minHeight = 0.0.obs;
  double get minHeight => _minHeight.value;
  set minHeight(double value) => _minHeight.value = value;

  late P properties;
  late L listener;
  late D dataSource;

  P propertiesBuilder() {
    throw UnimplementedError();
  }

  L listenerBuilder() {
    throw UnimplementedError();
  }

  D dataSourceBuilder() {
    throw UnimplementedError();
  }

  @mustCallSuper
  void init() {
    try {
      listener = listenerBuilder();
      Get.replace<L>(
        listener,
        tag: tag,
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      properties = propertiesBuilder();
      Get.replace<P>(
        properties,
        tag: tag,
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      dataSource = dataSourceBuilder();
      Get.replace<D>(
        dataSource,
        tag: tag,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    dataSource.init();
  }

  @mustCallSuper
  void ready() {
    if (isFixedBody) {
      RenderBox renderBox = appBarKey.currentContext?.findRenderObject() as RenderBox;
      double distraction = renderBox.size.height;
      _minHeight.value = Get.height - distraction;
    }
    listener.onRefresh();
  }

  @mustCallSuper
  void close() {
    Get.delete<P>(
      tag: tag,
    );
    Get.delete<L>(
      tag: tag,
    );
    Get.delete<D>(
      tag: tag,
    );
  }

  @mustCallSuper
  void reInit() {
    init();
    ready();
  }

  void refreshStates() {
    reInit();
    update([tag]);
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onReady() {
    super.onReady();
    ready();
  }

  @override
  void onClose() {
    close();
    super.onClose();
  }
}
