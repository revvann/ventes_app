import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/form_state_controller.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/presenters/contact_person_fc_presenter.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/app/states/form_sources/regular_form_source.dart';

part 'package:ventes/app/states/form_validators/contact_person_fc_validator.dart';
part 'package:ventes/app/states/data_sources/contact_person_fc_data_source.dart';
part 'package:ventes/app/states/form_sources/contact_person_fc_form_source.dart';
part 'package:ventes/app/states/listeners/contact_person_fc_listener.dart';

class ContactPersonFormCreateStateController extends FormStateController<_Properties, _Listener, _DataSource, _FormSource> {
  @override
  String get tag => ProspectString.contactCreateTag;

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
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.contactCreateTag);

  late int customerid;
  void refresh() {
    _dataSource.fetchData(customerid);
    Get.find<TaskHelper>().loaderPush(ProspectString.formCreateContactTaskCode);
  }
}
