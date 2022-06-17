part of 'package:ventes/app/states/controllers/prospect_assign_state_controller.dart';

class ProspectAssignProperty extends StateProperty {
  ProspectAssignDataSource get _dataSource => Get.find<ProspectAssignDataSource>(tag: ProspectString.prospectAssignTag);
  Set<String> popupControllers = {};

  late int prospectid;

  Task task = Task(ProspectString.prospectAssignTaskCode);

  void refresh() {
    _dataSource.fetchData(prospectid);
    Get.find<TaskHelper>().loaderPush(task);
  }

  PopupMenuController createPopupController([int id = 0]) {
    String tag = "popup_$id";
    popupControllers.add(tag);
    return Get.put(PopupMenuController(), tag: tag);
  }

  @override
  void close() {
    super.close();
    for (var element in popupControllers) {
      Get.delete<PopupMenuController>(tag: element);
    }
  }
}
