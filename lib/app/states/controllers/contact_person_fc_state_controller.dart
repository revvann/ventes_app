import 'package:get/get.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/contact_person_data_source.dart';
import 'package:ventes/app/states/data_sources/contact_person_fc_data_source.dart';
import 'package:ventes/app/states/form_sources/contact_person_fc_form_source.dart';
import 'package:ventes/app/states/listeners/contact_person_fc_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonFormCreateStateController extends RegularStateController {
  ContactPersonFormCreateListener listener = Get.put(ContactPersonFormCreateListener());
  ContactPersonFormCreateFormSource formSource = Get.put(ContactPersonFormCreateFormSource());
  ContactPersonFormCreateDataSource dataSource = Get.put(ContactPersonFormCreateDataSource());
  ContactPersonFormCreateProperties properties = Get.put(ContactPersonFormCreateProperties());

  @override
  void onClose() {
    formSource.close();
    Get.delete<ContactPersonFormCreateProperties>();
    Get.delete<ContactPersonFormCreateDataSource>();
    Get.delete<ContactPersonFormCreateFormSource>();
    Get.delete<ContactPersonFormCreateListener>();
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

class ContactPersonFormCreateProperties {
  ContactPersonFormCreateDataSource get _dataSource => Get.find<ContactPersonFormCreateDataSource>();

  late int customerid;
  void refresh() {
    _dataSource.fetchData(customerid);
    Get.find<TaskHelper>().loaderPush(ProspectString.formCreateContactTaskCode);
  }
}
