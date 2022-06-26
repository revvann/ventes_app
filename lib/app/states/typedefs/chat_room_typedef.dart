import 'package:ventes/app/states/controllers/chat_room_state_controller.dart';
import 'package:ventes/app/states/data/sources/chat_room_data_source.dart';
import 'package:ventes/app/states/listeners/chat_room_listener.dart';
import 'package:ventes/app/states/properties/chat_room_property.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/core/states/state_property.dart';

typedef Controller = ChatRoomStateController;

typedef Property = ChatRoomProperty;
typedef Listener = ChatRoomListener;
typedef DataSource = ChatRoomDataSource;
typedef FormSource = StateFormSource?;

typedef PropertyMixin = UnformablePropertyMixin<Controller, Listener, DataSource>;
typedef ListenerMixin = UnformableListenerMixin<Controller, Property, DataSource>;
typedef DataSourceMixin = UnformableDataSourceMixin<Controller, Property, Listener>;
