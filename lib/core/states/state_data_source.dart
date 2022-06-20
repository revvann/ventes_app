import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef UnformableDataSourceMixin<C extends StateController, P extends StateProperty?, L extends StateListener?> = StateDataSourceMixin<C, P, L, StateFormSource?>;

abstract class StateDataSource<T extends RegularPresenter> {
  late T presenter;

  T presenterBuilder();

  @mustCallSuper
  init() {
    presenter = presenterBuilder();
    presenter.contract = this;
  }

  @mustCallSuper
  ready() {}

  @mustCallSuper
  close() {}
}

mixin StateDataSourceMixin<C extends StateController, P extends StateProperty?, L extends StateListener?, F extends StateFormSource?> {
  C get _state => Get.find<C>();

  @protected
  P get property => _state.property as P;

  @protected
  L get listener => _state.listener as L;

  @protected
  F get formSource => _state.formSource as F;
}
