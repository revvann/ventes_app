part of 'package:ventes/app/states/controllers/contact_person_fc_state_controller.dart';

class ContactPersonFormCreateProperty extends StateProperty {
  late int customerid;

  ContactPersonFormCreateDataSource get _dataSource => Get.find<ContactPersonFormCreateDataSource>(tag: ProspectString.contactCreateTag);

  Task task = Task(ProspectString.formCreateContactTaskCode);

  void refresh() {
    _dataSource.fetchData(customerid);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
