part of 'package:ventes/app/states/controllers/prospect_assign_state_controller.dart';

class ProspectAssignListener extends StateListener {
  ProspectAssignProperty get _properties => Get.find<ProspectAssignProperty>(tag: ProspectString.prospectAssignTag);

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
