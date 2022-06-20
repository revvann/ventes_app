import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_property.dart';

typedef UnformableListenerMixin<C extends StateController, P extends StateProperty?, D extends StateDataSource?> = StateListenerMixin<C, P, D, StateFormSource?>;

abstract class StateListener {
  Future onReady();
}

mixin StateListenerMixin<C extends StateController, P extends StateProperty?, D extends StateDataSource?, F extends StateFormSource?> {
  C get _state => Get.find<C>();

  @protected
  P get property => _state.property as P;

  @protected
  D get dataSource => _state.dataSource as D;

  @protected
  F get formSource => _state.formSource as F;
}
