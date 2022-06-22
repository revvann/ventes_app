import 'package:ventes/app/states/controllers/schedule_state_controller.dart';
import 'package:ventes/app/states/listeners/schedule_listener.dart';
import 'package:ventes/app/states/data/sources/schedule_data_source.dart';
import 'package:ventes/app/states/properties/schedule_property.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ScheduleStateController;

typedef Property = ScheduleProperty;
typedef Listener = ScheduleListener;
typedef DataSource = ScheduleDataSource;
typedef FormSource = StateFormSource?;

typedef PropertyMixin = UnformablePropertyMixin<Controller, Listener, DataSource>;
typedef ListenerMixin = UnformableListenerMixin<Controller, Property, DataSource>;
typedef DataSourceMixin = UnformableDataSourceMixin<Controller, Property, Listener>;
