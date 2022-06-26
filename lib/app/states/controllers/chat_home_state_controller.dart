import 'package:ventes/app/states/typedefs/chat_home_typedef.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/core/states/state_controller.dart';

class ChatHomeStateController extends StateController<Property, Listener, DataSource, FormSource?> {
  @override
  String get tag => DashboardString.chatHomeTag;

  @override
  Property propertyBuilder() => Property();

  @override
  Listener listenerBuilder() => Listener();

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  FormSource? formSourceBuilder() => null;
}
