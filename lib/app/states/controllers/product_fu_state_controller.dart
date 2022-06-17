// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/core/states/form_state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/controllers/product_state_controller.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/prospect_product_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/api/presenters/product_fu_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/form/validators/product_fu_validator.dart';
part 'package:ventes/app/states/data_sources/product_fu_data_source.dart';
part 'package:ventes/app/states/form/sources/product_fu_form_source.dart';
part 'package:ventes/app/states/listeners/product_fu_listener.dart';
part 'package:ventes/app/states/properties/product_fu_property.dart';

class ProductFormUpdateStateController extends FormStateController<ProductFormUpdateProperty, ProductFormUpdateListener, ProductFormUpdateDataSource, ProductFormUpdateFormSource> {
  @override
  String get tag => ProspectString.productUpdateTag;

  @override
  ProductFormUpdateProperty propertiesBuilder() => ProductFormUpdateProperty();

  @override
  ProductFormUpdateListener listenerBuilder() => ProductFormUpdateListener();

  @override
  ProductFormUpdateDataSource dataSourceBuilder() => ProductFormUpdateDataSource();

  @override
  ProductFormUpdateFormSource formSourceBuilder() => ProductFormUpdateFormSource();
}
