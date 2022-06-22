import 'package:ventes/app/states/controllers/profile_state_controller.dart';
import 'package:ventes/app/states/data/sources/profile_data_source.dart';
import 'package:ventes/app/states/listeners/profile_listener.dart';
import 'package:ventes/app/states/properties/profile_property.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ProfileStateController;

typedef Property = ProfileProperty;
typedef Listener = ProfileListener;
typedef DataSource = ProfileDataSource;
typedef FormSource = StateFormSource?;

typedef PropertyMixin = UnformablePropertyMixin<Controller, Listener, DataSource>;
typedef ListenerMixin = UnformableListenerMixin<Controller, Property, DataSource>;
typedef DataSourceMixin = UnformableDataSourceMixin<Controller, Property, Listener>;
