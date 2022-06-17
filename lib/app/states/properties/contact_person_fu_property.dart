part of 'package:ventes/app/states/controllers/contact_person_fu_state_controller.dart';

class ContactPersonFormUpdateProperty extends StateProperty {
  ContactPersonFormUpdateDataSource get _dataSource => Get.find<ContactPersonFormUpdateDataSource>(tag: ProspectString.contactUpdateTag);

  Task task = Task(ProspectString.formUpdateContactTaskCode);

  late int contactid;
  void refresh() {
    _dataSource.fetchData(contactid);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
