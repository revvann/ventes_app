import 'package:get/get.dart';
import 'package:ventes/core/states/form_state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/prospect_detail_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/api/presenters/prospect_detail_fu_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/form/validators/prospect_detail_fu_validator.dart';
part 'package:ventes/app/states/data_sources/prospect_detail_fu_data_source.dart';
part 'package:ventes/app/states/form/sources/prospect_detail_fu_form_source.dart';
part 'package:ventes/app/states/listeners/prospect_detail_fu_listener.dart';
part 'package:ventes/app/states/properties/prospect_detail_fu_property.dart';

class ProspectDetailFormUpdateStateController
    extends FormStateController<ProspectDetailFormUpdateProperty, ProspectDetailFormUpdateListener, ProspectDetailFormUpdateDataSource, ProspectDetailFormUpdateFormSource> {
  @override
  String get tag => ProspectString.detailUpdateTag;

  @override
  ProspectDetailFormUpdateProperty propertiesBuilder() => ProspectDetailFormUpdateProperty();

  @override
  ProspectDetailFormUpdateListener listenerBuilder() => ProspectDetailFormUpdateListener();

  @override
  ProspectDetailFormUpdateDataSource dataSourceBuilder() => ProspectDetailFormUpdateDataSource();

  @override
  ProspectDetailFormUpdateFormSource formSourceBuilder() => ProspectDetailFormUpdateFormSource();
}
