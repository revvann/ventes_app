import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/core/states/form_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/api/presenters/prospect_fu_presenter.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:flutter/material.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/constants/formatters/currency_formatter.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/form/validators/prospect_fu_validator.dart';
part 'package:ventes/app/states/data_sources/prospect_fu_data_source.dart';
part 'package:ventes/app/states/form/sources/prospect_fu_form_source.dart';
part 'package:ventes/app/states/listeners/prospect_fu_listener.dart';
part 'package:ventes/app/states/properties/prospect_fu_property.dart';

class ProspectFormUpdateStateController extends FormStateController<ProspectFormUpdateProperty, ProspectFormUpdateListener, ProspectFormUpdateDataSource, ProspectFormUpdateFormSource> {
  @override
  String get tag => ProspectString.prospectUpdateTag;

  @override
  ProspectFormUpdateProperty propertiesBuilder() => ProspectFormUpdateProperty();

  @override
  ProspectFormUpdateListener listenerBuilder() => ProspectFormUpdateListener();

  @override
  ProspectFormUpdateDataSource dataSourceBuilder() => ProspectFormUpdateDataSource();

  @override
  ProspectFormUpdateFormSource formSourceBuilder() => ProspectFormUpdateFormSource();
}
