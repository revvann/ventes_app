// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/api/presenters/customer_fc_presenter.dart';
import 'package:ventes/core/states/form_state_controller.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:ventes/app/resources/widgets/search_list.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/form/sources/customer_fc_form_source.dart';
part 'package:ventes/app/states/data_sources/customer_fc_data_source.dart';
part 'package:ventes/app/states/listeners/customer_fc_listener.dart';
part 'package:ventes/app/states/form/validators/customer_fc_validator.dart';
part 'package:ventes/app/states/properties/customer_fc_property.dart';

class CustomerFormCreateStateController extends FormStateController<CustomerFormCreateProperty, CustomerFormCreateListener, CustomerFormCreateDataSource, CustomerFormCreateFormSource> {
  @override
  String get tag => NearbyString.customerCreateTag;

  @override
  CustomerFormCreateProperty propertiesBuilder() => CustomerFormCreateProperty();

  @override
  CustomerFormCreateListener listenerBuilder() => CustomerFormCreateListener();

  @override
  CustomerFormCreateDataSource dataSourceBuilder() => CustomerFormCreateDataSource();

  @override
  CustomerFormCreateFormSource formSourceBuilder() => CustomerFormCreateFormSource();
}
