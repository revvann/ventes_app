import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:meta/meta.dart';

abstract class StateProperty {
  @mustCallSuper
  void init() {}

  @mustCallSuper
  void ready() {}

  @mustCallSuper
  void close() {}
}

mixin StatePropertyMixin<C extends StateController, L extends StateListener?, D extends StateDataSource?, F extends StateFormSource?> on StateProperty {
  C get _state => Get.find<C>();

  @protected
  L get listener => _state.listener as L;

  @protected
  D get dataSource => _state.dataSource as D;

  @protected
  F get formSource => _state.formSource as F;
}
