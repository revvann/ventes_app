import 'package:ventes/app/states/controllers/chat_home_state_controller.dart';
import 'package:ventes/app/states/data/sources/chat_home_data_source.dart';
import 'package:ventes/app/states/listeners/chat_home_listener.dart';
import 'package:ventes/app/states/properties/chat_home_property.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ChatHomeStateController;

typedef Property = ChatHomeProperty;
typedef Listener = ChatHomeListener;
typedef DataSource = ChatHomeDataSource;
typedef FormSource = StateFormSource?;

typedef PropertyMixin = UnformablePropertyMixin<Controller, Listener, DataSource>;
typedef ListenerMixin = UnformableListenerMixin<Controller, Property, DataSource>;
typedef DataSourceMixin = UnformableDataSourceMixin<Controller, Property, Listener>;
