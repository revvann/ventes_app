part of 'package:ventes/app/states/controllers/contact_person_state_controller.dart';

class ContactPersonProperty extends StateProperty {
  ContactPersonDataSource get _dataSource => Get.find<ContactPersonDataSource>(tag: ProspectString.contactTag);
  Set<String> popupControllers = {};

  late int customerid;

  Task task = Task(ProspectString.contactPersonTaskCode);

  void refresh() {
    _dataSource.fetchData(customerid);
    Get.find<TaskHelper>().loaderPush(task);
  }

  PopupMenuController createPopupController([int id = 0]) {
    String tag = "popup_contact_$id";
    popupControllers.add(tag);
    return Get.put(PopupMenuController(), tag: tag);
  }

  @override
  void close() {
    super.close();
    for (var controller in popupControllers) {
      Get.delete<PopupMenuController>(tag: controller);
    }
  }
}
