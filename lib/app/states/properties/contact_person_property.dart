import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/contact_person_typedef.dart';

class ContactPersonProperty extends StateProperty {
  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.contactTag);
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
