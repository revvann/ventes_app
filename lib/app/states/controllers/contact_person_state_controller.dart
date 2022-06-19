import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/contact_person_typedef.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_form_source.dart';

class ContactPersonStateController extends StateController<Property, Listener, DataSource, StateFormSource?> {
  @override
  String get tag => ProspectString.contactTag;

  @override
  Property propertyBuilder() => Property();

  @override
  Listener listenerBuilder() => Listener();

  @override
  DataSource dataSourceBuilder() => DataSource();

  @override
  StateFormSource? formSourceBuilder() => null;
}
