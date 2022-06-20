import 'package:ventes/app/states/data_sources/customer_fc_data_source.dart';
import 'package:ventes/app/states/controllers/customer_fc_state_controller.dart';
import 'package:ventes/app/states/listeners/customer_fc_listener.dart';
import 'package:ventes/app/states/properties/customer_fc_property.dart';
import 'package:ventes/app/states/form/sources/customer_fc_form_source.dart';
import 'package:ventes/app/states/form/validators/customer_fc_validator.dart';

import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = CustomerFormCreateStateController;

typedef Property = CustomerFormCreateProperty;
typedef Listener = CustomerFormCreateListener;
typedef DataSource = CustomerFormCreateDataSource;
typedef FormSource = CustomerFormCreateFormSource;
typedef Validator = CustomerFormCreateValidator;

typedef PropertyMixin = StatePropertyMixin<Controller, Listener, DataSource, FormSource>;
typedef ListenerMixin = StateListenerMixin<Controller, Property, DataSource, FormSource>;
typedef DataSourceMixin = StateDataSourceMixin<Controller, Property, Listener, FormSource>;
typedef FormSourceMixin = StateFormSourceMixin<Controller, Property, Listener, DataSource>;
