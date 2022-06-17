part of 'package:ventes/app/states/controllers/prospect_fc_state_controller.dart';

class ProspectFormCreateProperty extends StateProperty {
  ProspectFormCreateDataSource get dataSource => Get.find<ProspectFormCreateDataSource>(tag: ProspectString.prospectCreateTag);
  ProspectFormCreateFormSource get formSource => Get.find<ProspectFormCreateFormSource>(tag: ProspectString.prospectCreateTag);

  Task task = Task(ProspectString.formCreateTaskCode);

  void refresh() {
    dataSource.fetchData();
    Get.find<TaskHelper>().loaderPush(task);
  }
}
