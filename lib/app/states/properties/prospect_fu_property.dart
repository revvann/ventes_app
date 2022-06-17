part of 'package:ventes/app/states/controllers/prospect_fu_state_controller.dart';

class ProspectFormUpdateProperty extends StateProperty {
  ProspectFormUpdateDataSource get dataSource => Get.find<ProspectFormUpdateDataSource>(tag: ProspectString.prospectUpdateTag);
  ProspectFormUpdateFormSource get formSource => Get.find<ProspectFormUpdateFormSource>(tag: ProspectString.prospectUpdateTag);

  late int prospectId;

  Task task = Task(ProspectString.formUpdateTaskCode);

  void refresh() {
    dataSource.fetchData(prospectId);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
