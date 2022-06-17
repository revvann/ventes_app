import 'package:get/get.dart';
import 'package:ventes/core/states/form_state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/api/presenters/prospect_fc_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/constants/formatters/currency_formatter.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/data_sources/prospect_fc_data_source.dart';
part 'package:ventes/app/states/form/sources/prospect_fc_form_source.dart';
part 'package:ventes/app/states/form/validators/prospect_fc_validator.dart';
part 'package:ventes/app/states/listeners/prospect_fc_listener.dart';
part 'package:ventes/app/states/properties/prospect_fc_property.dart';

class ProspectFormCreateStateController extends FormStateController<ProspectFormCreateProperty, ProspectFormCreateListener, ProspectFormCreateDataSource, ProspectFormCreateFormSource> {
  @override
  String get tag => ProspectString.prospectCreateTag;

  @override
  ProspectFormCreateProperty propertiesBuilder() => ProspectFormCreateProperty();

  @override
  ProspectFormCreateListener listenerBuilder() => ProspectFormCreateListener();

  @override
  ProspectFormCreateDataSource dataSourceBuilder() => ProspectFormCreateDataSource();

  @override
  ProspectFormCreateFormSource formSourceBuilder() => ProspectFormCreateFormSource();
}
