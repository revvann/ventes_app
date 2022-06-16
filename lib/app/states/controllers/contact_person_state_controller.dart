import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/regular_data_source.dart';
import 'package:ventes/app/states/listeners/regular_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/resources/views/contact_form/create/contact_person_fc.dart';
import 'package:ventes/app/resources/views/contact_form/update/contact_person_fu.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/app/network/presenters/contact_person_presenter.dart';

part 'package:ventes/app/states/data_sources/contact_person_data_source.dart';
part 'package:ventes/app/states/listeners/contact_person_listener.dart';

class ContactPersonStateController extends RegularStateController<_Properties, _Listener, _DataSource> {
  @override
  String get tag => ProspectString.contactTag;

  @override
  _Properties propertiesBuilder() => _Properties();

  @override
  _Listener listenerBuilder() => _Listener();

  @override
  _DataSource dataSourceBuilder() => _DataSource();

  @override
  void close() {
    super.close();
    for (var controller in properties.popupControllers) {
      Get.delete<PopupMenuController>(tag: controller);
    }
  }
}

class _Properties {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.contactTag);
  Set<String> popupControllers = {};

  late int customerid;

  void refresh() {
    _dataSource.fetchData(customerid);
    Get.find<TaskHelper>().loaderPush(ProspectString.contactPersonTaskCode);
  }

  PopupMenuController createPopupController([int id = 0]) {
    String tag = "popup_contact_$id";
    popupControllers.add(tag);
    return Get.put(PopupMenuController(), tag: tag);
  }
}
