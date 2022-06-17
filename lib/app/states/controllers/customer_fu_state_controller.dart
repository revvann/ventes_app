// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/core/states/form_state_controller.dart';
import 'package:ventes/app/states/controllers/nearby_state_controller.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/subdistrict_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/api/presenters/customer_fu_presenter.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/routing/navigators/nearby_navigator.dart';
import 'package:path/path.dart' as path;
import 'package:ventes/app/resources/widgets/search_list.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/form/sources/customer_fu_form_source.dart';
part 'package:ventes/app/states/listeners/customer_fu_listener.dart';
part 'package:ventes/app/states/data_sources/customer_fu_data_source.dart';
part 'package:ventes/app/states/form/validators/customer_fu_validator.dart';
part 'package:ventes/app/states/properties/customer_fu_property.dart';

class CustomerFormUpdateStateController extends FormStateController<CustomerFormUpdateProperty, CustomerFormUpdateListener, CustomerFormUpdateDataSource, CustomerFormUpdateFormSource> {
  @override
  String get tag => NearbyString.customerUpdateTag;

  @override
  CustomerFormUpdateProperty propertiesBuilder() => CustomerFormUpdateProperty();

  @override
  CustomerFormUpdateListener listenerBuilder() => CustomerFormUpdateListener();

  @override
  CustomerFormUpdateDataSource dataSourceBuilder() => CustomerFormUpdateDataSource();

  @override
  CustomerFormUpdateFormSource formSourceBuilder() => CustomerFormUpdateFormSource();
}
