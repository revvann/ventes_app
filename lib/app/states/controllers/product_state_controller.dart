// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/resources/views/product_form/update/product_fu.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/prospect_product_model.dart';
import 'package:ventes/app/api/presenters/product_presenter.dart';

part 'package:ventes/app/states/data_sources/product_data_source.dart';
part 'package:ventes/app/states/listeners/product_listener.dart';
part 'package:ventes/app/states/properties/product_property.dart';

class ProductStateController extends RegularStateController<ProductProperty, ProductListener, ProductDataSource> {
  @override
  String get tag => ProspectString.productTag;

  @override
  ProductProperty propertiesBuilder() => ProductProperty();

  @override
  ProductListener listenerBuilder() => ProductListener();

  @override
  ProductDataSource dataSourceBuilder() => ProductDataSource();
}
