import 'package:ventes/app/states/data/sources/contact_person_fu_data_source.dart';
import 'package:ventes/app/states/controllers/contact_person_fu_state_controller.dart';
import 'package:ventes/app/states/form/validators/contact_person_fu_validator.dart';
import 'package:ventes/app/states/listeners/contact_person_fu_listener.dart';
import 'package:ventes/app/states/properties/contact_person_fu_property.dart';
import 'package:ventes/app/states/form/sources/contact_person_fu_form_source.dart';

import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ContactPersonFormUpdateStateController;

typedef Property = ContactPersonFormUpdateProperty;
typedef Listener = ContactPersonFormUpdateListener;
typedef DataSource = ContactPersonFormUpdateDataSource;
typedef FormSource = ContactPersonFormUpdateFormSource;
typedef Validator = ContactPersonFormUpdateValidator;

typedef PropertyMixin = StatePropertyMixin<Controller, Listener, DataSource, FormSource>;
typedef ListenerMixin = StateListenerMixin<Controller, Property, DataSource, FormSource>;
typedef DataSourceMixin = StateDataSourceMixin<Controller, Property, Listener, FormSource>;
typedef FormSourceMixin = StateFormSourceMixin<Controller, Property, Listener, DataSource>;
