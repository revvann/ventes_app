import 'package:ventes/app/states/controllers/prospect_assign_state_controller.dart';
import 'package:ventes/app/states/listeners/prospect_assign_listener.dart';
import 'package:ventes/app/states/data_sources/prospect_assign_data_source.dart';
import 'package:ventes/app/states/properties/prospect_assign_property.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProspectAssignStateController;

typedef Property = ProspectAssignProperty;
typedef Listener = ProspectAssignListener;
typedef DataSource = ProspectAssignDataSource;
typedef FormSource = StateFormSource?;

typedef PropertyMixin = UnformablePropertyMixin<Controller, Listener, DataSource>;
typedef ListenerMixin = UnformableListenerMixin<Controller, Property, DataSource>;
typedef DataSourceMixin = UnformableDataSourceMixin<Controller, Property, Listener>;
