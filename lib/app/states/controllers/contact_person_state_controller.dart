import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/resources/views/contact_form/create/contact_person_fc.dart';
import 'package:ventes/app/resources/views/contact_form/update/contact_person_fu.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/app/api/presenters/contact_person_presenter.dart';
import 'package:ventes/core/states/state_property.dart';

part 'package:ventes/app/states/data_sources/contact_person_data_source.dart';
part 'package:ventes/app/states/listeners/contact_person_listener.dart';
part 'package:ventes/app/states/properties/contact_person_property.dart';

class ContactPersonStateController extends RegularStateController<ContactPersonProperty, ContactPersonListener, ContactPersonDataSource> {
  @override
  String get tag => ProspectString.contactTag;

  @override
  ContactPersonProperty propertiesBuilder() => ContactPersonProperty();

  @override
  ContactPersonListener listenerBuilder() => ContactPersonListener();

  @override
  ContactPersonDataSource dataSourceBuilder() => ContactPersonDataSource();
}
