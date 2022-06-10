import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/form_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/form_sources/regular_form_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/presenters/prospect_detail_fc_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:ventes/helpers/function_helpers.dart';

part 'package:ventes/app/states/form_validators/prospect_detail_fc_validator.dart';
part 'package:ventes/app/states/data_sources/prospect_detail_fc_data_source.dart';
part 'package:ventes/app/states/form_sources/prospect_detail_fc_form_source.dart';
part 'package:ventes/app/states/listeners/prospect_detail_fc_listener.dart';

class ProspectDetailFormCreateStateController extends FormStateController<_Properties, _Listener, _DataSource, _FormSource> {
  @override
  String get tag => ProspectString.detailCreateTag;

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
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.detailCreateTag);

  late int prospectId;

  refresh() {
    _dataSource.fetchData(prospectId);
    Get.find<TaskHelper>().loaderPush(ProspectString.formCreateDetailTaskCode);
  }
}
