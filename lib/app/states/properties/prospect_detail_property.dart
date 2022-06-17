part of 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';

class ProspectDetailProperty extends StateProperty {
  ProspectDetailDataSource get _dataSource => Get.find<ProspectDetailDataSource>(tag: ProspectString.detailTag);
  late int prospectId;
  Set<String> popupControllers = {};

  Task task = Task(ProspectString.detailTaskCode);

  refresh() {
    _dataSource.fetchData(prospectId);
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
