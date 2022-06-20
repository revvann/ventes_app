import 'package:ventes/app/states/controllers/prospect_fu_state_controller.dart';
import 'package:ventes/app/states/form/validators/prospect_fu_validator.dart';
import 'package:ventes/app/states/listeners/prospect_fu_listener.dart';
import 'package:ventes/app/states/form/sources/prospect_fu_form_source.dart';
import 'package:ventes/app/states/data_sources/prospect_fu_data_source.dart';
import 'package:ventes/app/states/properties/prospect_fu_property.dart';

import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProspectFormUpdateStateController;

typedef Property = ProspectFormUpdateProperty;
typedef Listener = ProspectFormUpdateListener;
typedef DataSource = ProspectFormUpdateDataSource;
typedef FormSource = ProspectFormUpdateFormSource;
typedef Validator = ProspectFormUpdateValidator;

typedef PropertyMixin = StatePropertyMixin<Controller, Listener, DataSource, FormSource>;
typedef ListenerMixin = StateListenerMixin<Controller, Property, DataSource, FormSource>;
typedef DataSourceMixin = StateDataSourceMixin<Controller, Property, Listener, FormSource>;
typedef FormSourceMixin = StateFormSourceMixin<Controller, Property, Listener, DataSource>;
