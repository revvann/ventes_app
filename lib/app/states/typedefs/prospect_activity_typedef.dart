import 'package:ventes/app/states/controllers/prospect_activity_state_controller.dart';
import 'package:ventes/app/states/listeners/prospect_activity_listener.dart';
import 'package:ventes/app/states/data/sources/prospect_activity_data_source.dart';
import 'package:ventes/app/states/properties/prospect_activity_property.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProspectActivityStateController;

typedef Property = ProspectActivityProperty;
typedef Listener = ProspectActivityListener;
typedef DataSource = ProspectActivityDataSource;
typedef FormSource = StateFormSource?;

typedef PropertyMixin = UnformablePropertyMixin<Controller, Listener, DataSource>;
typedef ListenerMixin = UnformableListenerMixin<Controller, Property, DataSource>;
typedef DataSourceMixin = UnformableDataSourceMixin<Controller, Property, Listener>;
