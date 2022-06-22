import 'package:ventes/app/states/controllers/product_fu_state_controller.dart';
import 'package:ventes/app/states/form/validators/product_fu_validator.dart';
import 'package:ventes/app/states/listeners/product_fu_listener.dart';
import 'package:ventes/app/states/form/sources/product_fu_form_source.dart';
import 'package:ventes/app/states/data/sources/product_fu_data_source.dart';
import 'package:ventes/app/states/properties/product_fu_property.dart';

import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProductFormUpdateStateController;

typedef Property = ProductFormUpdateProperty;
typedef Listener = ProductFormUpdateListener;
typedef DataSource = ProductFormUpdateDataSource;
typedef FormSource = ProductFormUpdateFormSource;
typedef Validator = ProductFormUpdateValidator;

typedef PropertyMixin = StatePropertyMixin<Controller, Listener, DataSource, FormSource>;
typedef ListenerMixin = StateListenerMixin<Controller, Property, DataSource, FormSource>;
typedef DataSourceMixin = StateDataSourceMixin<Controller, Property, Listener, FormSource>;
typedef FormSourceMixin = StateFormSourceMixin<Controller, Property, Listener, DataSource>;
