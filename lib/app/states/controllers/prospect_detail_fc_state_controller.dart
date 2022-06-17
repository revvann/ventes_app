import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/core/states/form_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/api/presenters/prospect_detail_fc_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/form/validators/prospect_detail_fc_validator.dart';
part 'package:ventes/app/states/data_sources/prospect_detail_fc_data_source.dart';
part 'package:ventes/app/states/form/sources/prospect_detail_fc_form_source.dart';
part 'package:ventes/app/states/listeners/prospect_detail_fc_listener.dart';
part 'package:ventes/app/states/properties/prospect_detail_fc_property.dart';

class ProspectDetailFormCreateStateController
    extends FormStateController<ProspectDetailFormCreateProperty, ProspectDetailFormCreateListener, ProspectDetailFormCreateDataSource, ProspectDetailFormCreateFormSource> {
  @override
  String get tag => ProspectString.detailCreateTag;

  @override
  ProspectDetailFormCreateProperty propertiesBuilder() => ProspectDetailFormCreateProperty();

  @override
  ProspectDetailFormCreateListener listenerBuilder() => ProspectDetailFormCreateListener();

  @override
  ProspectDetailFormCreateDataSource dataSourceBuilder() => ProspectDetailFormCreateDataSource();

  @override
  ProspectDetailFormCreateFormSource formSourceBuilder() => ProspectDetailFormCreateFormSource();
}
