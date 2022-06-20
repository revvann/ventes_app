import 'package:ventes/app/states/controllers/schedule_fc_state_controller.dart';
import 'package:ventes/app/states/listeners/schedule_fc_listener.dart';
import 'package:ventes/app/states/form/sources/schedule_fc_form_source.dart';
import 'package:ventes/app/states/data_sources/schedule_fc_data_source.dart';
import 'package:ventes/app/states/properties/schedule_fc_property.dart';
import 'package:ventes/app/states/form/validators/schedule_fc_validator.dart';

import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ScheduleFormCreateStateController;

typedef Property = ScheduleFormCreateProperty;
typedef Listener = ScheduleFormCreateListener;
typedef DataSource = ScheduleFormCreateDataSource;
typedef FormSource = ScheduleFormCreateFormSource;
typedef Validator = ScheduleFormCreateValidator;

typedef PropertyMixin = StatePropertyMixin<Controller, Listener, DataSource, FormSource>;
typedef ListenerMixin = StateListenerMixin<Controller, Property, DataSource, FormSource>;
typedef DataSourceMixin = StateDataSourceMixin<Controller, Property, Listener, FormSource>;
typedef FormSourceMixin = StateFormSourceMixin<Controller, Property, Listener, DataSource>;
