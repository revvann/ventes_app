import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

abstract class StateFormSource {
  void onSubmit();

  @mustCallSuper
  void init() {}

  @mustCallSuper
  void ready() {}

  @mustCallSuper
  void close() {}

  Map<String, dynamic> toJson();
}

mixin StateFormSourceMixin<C extends StateController, P extends StateProperty?, L extends StateListener?, D extends StateDataSource?> {
  C get _state => Get.find<C>();

  @protected
  P get property => _state.property as P;

  @protected
  L get listener => _state.listener as L;

  @protected
  D get dataSource => _state.dataSource as D;
}
