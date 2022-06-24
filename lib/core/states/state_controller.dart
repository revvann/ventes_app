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

  ///
  /// use init method only when you need to initialize lateable variables
  /// if you dont, use ready method instead
  /// in this method datasource, listener and property will be initialized, and not ready to use yet
  ///
  @mustCallSuper
  void init() {
    listener = listenerBuilder();
    property = propertyBuilder();
    dataSource = dataSourceBuilder();
    formSource = formSourceBuilder();

    property?.init();
    dataSource?.init();
    formSource?.init();
  }

  ///
  /// ready method will called when controller is ready (in first Get.find)
  /// usually you want to use this method to get data from api, initialize view controller, or modify view
  ///
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
