import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/profile_typedef.dart';
import 'package:ventes/core/states/state_controller.dart';

class ProfileStateController extends StateController<Property, Listener, DataSource, FormSource> {
  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  FormSource? formSourceBuilder() => null;

  @override
  Listener listenerBuilder() => Listener();

  @override
  Property propertyBuilder() => Property();
}
