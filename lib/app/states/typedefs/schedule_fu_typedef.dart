import 'package:ventes/app/states/controllers/schedule_fu_state_controller.dart';
import 'package:ventes/app/states/form/validators/schedule_fu_validator.dart';
import 'package:ventes/app/states/listeners/schedule_fu_listener.dart';
import 'package:ventes/app/states/form/sources/schedule_fu_form_source.dart';
import 'package:ventes/app/states/data/sources/schedule_fu_data_source.dart';
import 'package:ventes/app/states/properties/schedule_fu_property.dart';

import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ScheduleFormUpdateStateController;

typedef Property = ScheduleFormUpdateProperty;
typedef Listener = ScheduleFormUpdateListener;
typedef DataSource = ScheduleFormUpdateDataSource;
typedef FormSource = ScheduleFormUpdateFormSource;
typedef Validator = ScheduleFormUpdateValidator;

typedef PropertyMixin = StatePropertyMixin<Controller, Listener, DataSource, FormSource>;
typedef ListenerMixin = StateListenerMixin<Controller, Property, DataSource, FormSource>;
typedef DataSourceMixin = StateDataSourceMixin<Controller, Property, Listener, FormSource>;
typedef FormSourceMixin = StateFormSourceMixin<Controller, Property, Listener, DataSource>;
