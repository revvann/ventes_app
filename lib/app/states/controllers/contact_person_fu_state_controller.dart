import 'package:get/get.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/contact_person_data_source.dart';
import 'package:ventes/app/states/data_sources/contact_person_fu_data_source.dart';
import 'package:ventes/app/states/form_sources/contact_person_fu_form_source.dart';
import 'package:ventes/app/states/listeners/contact_person_fu_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonFormUpdateStateController extends RegularStateController {
  ContactPersonFormUpdateListener listener = Get.put(ContactPersonFormUpdateListener());
  ContactPersonFormUpdateFormSource formSource = Get.put(ContactPersonFormUpdateFormSource());
  ContactPersonFormUpdateDataSource dataSource = Get.put(ContactPersonFormUpdateDataSource());
  ContactPersonFormUpdateProperties properties = Get.put(ContactPersonFormUpdateProperties());

  @override
  void onClose() {
    formSource.close();
    Get.delete<ContactPersonFormUpdateProperties>();
    Get.delete<ContactPersonFormUpdateDataSource>();
    Get.delete<ContactPersonFormUpdateFormSource>();
    Get.delete<ContactPersonFormUpdateListener>();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    dataSource.init();
    formSource.init();
  }

  @override
  void onReady() {
    super.onReady();
    properties.refresh();
  }
}

class ContactPersonFormUpdateProperties {
  ContactPersonFormUpdateDataSource get _dataSource => Get.find<ContactPersonFormUpdateDataSource>();

  late int contactid;
  void refresh() {
    _dataSource.fetchData(contactid);
    Get.find<TaskHelper>().loaderPush(ProspectString.formUpdateContactTaskCode);
  }
}
