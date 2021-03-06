import 'package:ventes/app/states/controllers/prospect_activity_fu_state_controller.dart';
import 'package:ventes/app/states/form/validators/prospect_activity_fu_validator.dart';
import 'package:ventes/app/states/listeners/prospect_activity_fu_listener.dart';
import 'package:ventes/app/states/form/sources/prospect_activity_fu_form_source.dart';
import 'package:ventes/app/states/data/sources/prospect_activity_fu_data_source.dart';
import 'package:ventes/app/states/properties/prospect_activity_fu_property.dart';

import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProspectActivityFormUpdateStateController;

typedef Property = ProspectActivityFormUpdateProperty;
typedef Listener = ProspectActivityFormUpdateListener;
typedef DataSource = ProspectActivityFormUpdateDataSource;
typedef FormSource = ProspectActivityFormUpdateFormSource;
typedef Validator = ProspectActivityFormUpdateValidator;

typedef PropertyMixin = StatePropertyMixin<Controller, Listener, DataSource, FormSource>;
typedef ListenerMixin = StateListenerMixin<Controller, Property, DataSource, FormSource>;
typedef DataSourceMixin = StateDataSourceMixin<Controller, Property, Listener, FormSource>;
typedef FormSourceMixin = StateFormSourceMixin<Controller, Property, Listener, DataSource>;
