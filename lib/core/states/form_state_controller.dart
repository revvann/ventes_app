import 'package:get/get.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

abstract class FormStateController<P extends StateProperty, L extends StateListener, D extends StateDataSource, F extends StateFormSource> extends RegularStateController<P, L, D> {
  late F formSource;

  F formSourceBuilder() {
    throw UnimplementedError();
  }

  @override
  init() {
    super.init();
    formSource = formSourceBuilder();
    Get.replace<F>(
      formSource,
      tag: tag,
    );
    formSource.init();
  }

  @override
  void ready() {
    super.ready();
    formSource.ready();
  }

  @override
  void close() {
    super.close();
    formSource.close();
    Get.delete<F>(
      tag: tag,
    );
  }
}
