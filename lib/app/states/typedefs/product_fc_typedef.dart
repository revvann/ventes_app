import 'package:ventes/app/states/controllers/product_fc_state_controller.dart';
import 'package:ventes/app/states/form/validators/product_fc_validator.dart';
import 'package:ventes/app/states/listeners/product_fc_listener.dart';
import 'package:ventes/app/states/form/sources/product_fc_form_source.dart';
import 'package:ventes/app/states/data/sources/product_fc_data_source.dart';
import 'package:ventes/app/states/properties/product_fc_property.dart';

import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProductFormCreateStateController;

typedef Property = ProductFormCreateProperty;
typedef Listener = ProductFormCreateListener;
typedef DataSource = ProductFormCreateDataSource;
typedef FormSource = ProductFormCreateFormSource;
typedef Validator = ProductFormCreateValidator;

typedef PropertyMixin = StatePropertyMixin<Controller, Listener, DataSource, FormSource>;
typedef ListenerMixin = StateListenerMixin<Controller, Property, DataSource, FormSource>;
typedef DataSourceMixin = StateDataSourceMixin<Controller, Property, Listener, FormSource>;
typedef FormSourceMixin = StateFormSourceMixin<Controller, Property, Listener, DataSource>;
