part of 'package:ventes/app/states/controllers/prospect_assign_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.prospectAssignTag);

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.prospectAssignTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.prospectAssignTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.prospectAssignTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.prospectAssignTaskCode);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
