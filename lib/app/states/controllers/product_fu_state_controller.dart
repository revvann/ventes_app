// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/form_state_controller.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/form_sources/update_form_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/prospect_product_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/presenters/product_fu_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:ventes/helpers/function_helpers.dart';

part 'package:ventes/app/states/form_validators/product_fu_validator.dart';
part 'package:ventes/app/states/data_sources/product_fu_data_source.dart';
part 'package:ventes/app/states/form_sources/product_fu_form_source.dart';
part 'package:ventes/app/states/listeners/product_fu_listener.dart';

class ProductFormUpdateStateController extends FormStateController<_Properties, _Listener, _DataSource, _FormSource> {
  @override
  String get tag => ProspectString.productUpdateTag;

  @override
  _Properties propertiesBuilder() => _Properties();

  @override
  _Listener listenerBuilder() => _Listener();

  @override
  _DataSource dataSourceBuilder() => _DataSource();

  @override
  _FormSource formSourceBuilder() => _FormSource();
}

class _Properties {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.productUpdateTag);
  late int productid;

  Task task = Task(ProspectString.formUpdateProductTaskCode);

  void refresh() {
    _dataSource.fetchData(productid);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
