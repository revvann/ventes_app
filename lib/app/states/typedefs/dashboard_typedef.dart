import 'package:ventes/app/states/data_sources/dashboard_data_source.dart';
import 'package:ventes/app/states/controllers/dashboard_state_controller.dart';
import 'package:ventes/app/states/listeners/dashboard_listener.dart';
import 'package:ventes/app/states/properties/dashboard_property.dart';
import 'package:ventes/core/states/state_form_source.dart';

typedef Controller = DashboardStateController;

typedef Property = DashboardProperty;
typedef DataSource = DashboardDataSource;
typedef Listener = DashboardListener;
typedef FormSource = StateFormSource?;
