import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

abstract class RegularStateController<P extends StateProperty, L extends StateListener, D extends StateDataSource> extends GetxController {
  final GlobalKey appBarKey = GlobalKey();
  bool get isFixedBody => true;
  String get tag => "";

  void Function(Duration)? onPostFrame;

  final _minHeight = 0.0.obs;
  double get minHeight => _minHeight.value;
  set minHeight(double value) => _minHeight.value = value;

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(bool value) => _loading.value = value;

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
    properties.init();
  }

  @mustCallSuper
  void ready() {
    if (isFixedBody) {
      RenderBox renderBox = appBarKey.currentContext?.findRenderObject() as RenderBox;
      double distraction = renderBox.size.height;
      _minHeight.value = Get.height - distraction;
    }
    properties.ready();
    dataSource.ready();
    listener.onRefresh();
  }

  @mustCallSuper
  void close() {
    loading = false;
    Get.delete<P>(
      tag: tag,
    );
    Get.delete<L>(
      tag: tag,
    );
    Get.delete<D>(
      tag: tag,
    );
    dataSource.close();
    properties.close();
  }

  void refreshStates() {
    onPostFrame ??= (_) {
      ready();
    };
    SchedulerBinding.instance?.addPostFrameCallback(onPostFrame!);
    close();
    init();
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
