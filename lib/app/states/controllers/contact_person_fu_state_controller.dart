import 'package:get/get.dart';
import 'package:ventes/app/network/presenters/contact_person_fu_presenter.dart';
import 'package:ventes/app/states/controllers/form_state_controller.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/form_sources/update_form_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:flutter/material.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';

part 'package:ventes/app/states/form_validators/contact_person_fu_validator.dart';
part 'package:ventes/app/states/data_sources/contact_person_fu_data_source.dart';
part 'package:ventes/app/states/form_sources/contact_person_fu_form_source.dart';
part 'package:ventes/app/states/listeners/contact_person_fu_listener.dart';

class ContactPersonFormUpdateStateController extends FormStateController<_Properties, _Listener, _DataSource, _FormSource> {
  @override
  String get tag => ProspectString.contactUpdateTag;

  @override
  _Properties propertiesBuilder() => _Properties();

  @override
  _Listener listenerBuilder() => _Listener();

  @override
  _DataSource dataSourceBuilder() => _DataSource();

  @override
  _FormSource formSourceBuilder() => _FormSource();
}

class _Properties {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.contactUpdateTag);

  late int contactid;
  void refresh() {
    _dataSource.fetchData(contactid);
    Get.find<TaskHelper>().loaderPush(ProspectString.formUpdateContactTaskCode);
  }
}
