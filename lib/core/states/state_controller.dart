import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

///
/// State controller has 4 components
/// each component is optional
/// if you dont wanna use it, just set it to null (add ? after the type)
///
abstract class StateController<P extends StateProperty?, L extends StateListener?, D extends StateDataSource?, F extends StateFormSource?> extends GetxController {
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

  late P property;
  late L listener;
  late D dataSource;
  late F formSource;

  ///
  /// if property is optional, set it to null
  ///
  P propertyBuilder();

  ///
  /// if listener is optional, set it to null
  ///
  L listenerBuilder();

  ///
  /// if dataSource is optional, set it to null
  ///
  D dataSourceBuilder();

  ///
  /// if formSource is optional, set it to null
  ///
  F formSourceBuilder();

  @mustCallSuper
  void init() {
    listener = listenerBuilder();
    property = propertyBuilder();
    dataSource = dataSourceBuilder();
    formSource = formSourceBuilder();

    Get.replace<L>(listener, tag: tag);
    Get.replace<P>(property, tag: tag);
    Get.replace<D>(dataSource, tag: tag);
    Get.replace<F>(formSource, tag: tag);

    dataSource?.init();
    property?.init();
    formSource?.init();
  }

  @mustCallSuper
  void ready() {
    // this code is executed for calculate app bar and body height
    if (isFixedBody) {
      RenderBox renderBox = appBarKey.currentContext?.findRenderObject() as RenderBox;
      double distraction = renderBox.size.height;
      _minHeight.value = Get.height - distraction;
    }
    property?.ready();
    dataSource?.ready();
    listener?.onReady();
    formSource?.ready();
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
    dataSource?.close();
    property?.close();
    formSource?.close();
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
