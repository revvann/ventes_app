import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/contact_person_fu_presenter.dart';
import 'package:ventes/core/states/form_state_controller.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:flutter/material.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';

part 'package:ventes/app/states/form/validators/contact_person_fu_validator.dart';
part 'package:ventes/app/states/data_sources/contact_person_fu_data_source.dart';
part 'package:ventes/app/states/form/sources/contact_person_fu_form_source.dart';
part 'package:ventes/app/states/listeners/contact_person_fu_listener.dart';
part 'package:ventes/app/states/properties/contact_person_fu_property.dart';

class ContactPersonFormUpdateStateController
    extends FormStateController<ContactPersonFormUpdateProperty, ContactPersonFormUpdateListener, ContactPersonFormUpdateDataSource, ContactPersonFormUpdateFormSource> {
  @override
  String get tag => ProspectString.contactUpdateTag;

  @override
  ContactPersonFormUpdateProperty propertiesBuilder() => ContactPersonFormUpdateProperty();

  @override
  ContactPersonFormUpdateListener listenerBuilder() => ContactPersonFormUpdateListener();

  @override
  ContactPersonFormUpdateDataSource dataSourceBuilder() => ContactPersonFormUpdateDataSource();

  @override
  ContactPersonFormUpdateFormSource formSourceBuilder() => ContactPersonFormUpdateFormSource();
}
