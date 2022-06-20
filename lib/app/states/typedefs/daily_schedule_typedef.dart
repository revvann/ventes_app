import 'package:ventes/app/states/data_sources/daily_schedule_data_source.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/app/states/listeners/daily_schedule_listener.dart';
import 'package:ventes/app/states/properties/daily_schedule_property.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = DailyScheduleStateController;

typedef Property = DailyScheduleProperty;
typedef Listener = DailyScheduleListener;
typedef DataSource = DailyScheduleDataSource;
typedef FormSource = StateFormSource?;

typedef PropertyMixin = UnformablePropertyMixin<Controller, Listener, DataSource>;
typedef ListenerMixin = UnformableListenerMixin<Controller, Property, DataSource>;
typedef DataSourceMixin = UnformableDataSourceMixin<Controller, Property, Listener>;
