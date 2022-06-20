import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/form_sources/regular_form_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';

abstract class FormStateController<P, L extends RegularListener, D extends RegularDataSource, F extends RegularFormSource> extends RegularStateController<P, L, D> {
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
  void close() {
    super.close();
    formSource.close();
    Get.delete<F>(
      tag: tag,
    );
  }
}
