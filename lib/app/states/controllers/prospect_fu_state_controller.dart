import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/controllers/form_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/app/states/form_sources/update_form_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/presenters/prospect_fu_presenter.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:flutter/material.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/constants/formatters/currency_formatter.dart';
import 'package:ventes/helpers/function_helpers.dart';

part 'package:ventes/app/states/form_validators/prospect_fu_validator.dart';
part 'package:ventes/app/states/data_sources/prospect_fu_data_source.dart';
part 'package:ventes/app/states/form_sources/prospect_fu_form_source.dart';
part 'package:ventes/app/states/listeners/prospect_fu_listener.dart';

class ProspectFormUpdateStateController extends FormStateController<_Properties, _Listener, _DataSource, _FormSource> {
  @override
  String get tag => ProspectString.prospectUpdateTag;

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
  _DataSource get dataSource => Get.find<_DataSource>(tag: ProspectString.prospectUpdateTag);
  _FormSource get formSource => Get.find<_FormSource>(tag: ProspectString.prospectUpdateTag);

  late int prospectId;

  Task task = Task(ProspectString.formUpdateTaskCode);

  void refresh() {
    dataSource.fetchData(prospectId);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
