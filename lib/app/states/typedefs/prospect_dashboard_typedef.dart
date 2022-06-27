import 'package:ventes/app/states/controllers/prospect_dashboard_state_controller.dart';
import 'package:ventes/app/states/data/sources/prospect_dashboard_data_source.dart';
import 'package:ventes/app/states/listeners/prospect_dashboard_listener.dart';
import 'package:ventes/app/states/properties/prospect_dashboard_property.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProspectDashboardStateController;

typedef Property = ProspectDashboardProperty;
typedef Listener = ProspectDashboardListener;
typedef DataSource = ProspectDashboardDataSource;
typedef FormSource = StateFormSource?;

typedef PropertyMixin = UnformablePropertyMixin<Controller, Listener, DataSource>;
typedef ListenerMixin = UnformableListenerMixin<Controller, Property, DataSource>;
typedef DataSourceMixin = UnformableDataSourceMixin<Controller, Property, Listener>;
