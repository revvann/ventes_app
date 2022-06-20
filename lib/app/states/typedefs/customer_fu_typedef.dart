import 'package:ventes/app/states/data_sources/customer_fu_data_source.dart';
import 'package:ventes/app/states/controllers/customer_fu_state_controller.dart';
import 'package:ventes/app/states/form/validators/customer_fu_validator.dart';
import 'package:ventes/app/states/listeners/customer_fu_listener.dart';
import 'package:ventes/app/states/properties/customer_fu_property.dart';
import 'package:ventes/app/states/form/sources/customer_fu_form_source.dart';

import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = CustomerFormUpdateStateController;

typedef Property = CustomerFormUpdateProperty;
typedef Listener = CustomerFormUpdateListener;
typedef DataSource = CustomerFormUpdateDataSource;
typedef FormSource = CustomerFormUpdateFormSource;
typedef Validator = CustomerFormUpdateValidator;

typedef PropertyMixin = StatePropertyMixin<Controller, Listener, DataSource, FormSource>;
typedef ListenerMixin = StateListenerMixin<Controller, Property, DataSource, FormSource>;
typedef DataSourceMixin = StateDataSourceMixin<Controller, Property, Listener, FormSource>;
typedef FormSourceMixin = StateFormSourceMixin<Controller, Property, Listener, DataSource>;
