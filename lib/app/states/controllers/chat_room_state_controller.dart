import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/core/states/state_controller.dart';

class ChatRoomStateController extends StateController<Property, Listener, DataSource, FormSource?> {
  @override
  String get tag => DashboardString.chatRoomTag;

  @override
  Property propertyBuilder() => Property();

  @override
  Listener listenerBuilder() => Listener();

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  FormSource? formSourceBuilder() => null;

  @override
  bool get isFixedBody => false;
}
