import 'package:ventes/app/states/data_sources/contact_person_fc_data_source.dart';
import 'package:ventes/app/states/controllers/contact_person_fc_state_controller.dart';
import 'package:ventes/app/states/listeners/contact_person_fc_listener.dart';
import 'package:ventes/app/states/properties/contact_person_fc_property.dart';
import 'package:ventes/app/states/form/sources/contact_person_fc_form_source.dart';
import 'package:ventes/app/states/form/validators/contact_person_fc_validator.dart';

import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ContactPersonFormCreateStateController;

typedef Property = ContactPersonFormCreateProperty;
typedef Listener = ContactPersonFormCreateListener;
typedef DataSource = ContactPersonFormCreateDataSource;
typedef FormSource = ContactPersonFormCreateFormSource;
typedef Validator = ContactPersonFormCreateValidator;

typedef PropertyMixin = StatePropertyMixin<Controller, Listener, DataSource, FormSource>;
typedef ListenerMixin = StateListenerMixin<Controller, Property, DataSource, FormSource>;
typedef DataSourceMixin = StateDataSourceMixin<Controller, Property, Listener, FormSource>;
typedef FormSourceMixin = StateFormSourceMixin<Controller, Property, Listener, DataSource>;
