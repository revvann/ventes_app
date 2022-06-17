part of 'package:ventes/app/states/controllers/prospect_state_controller.dart';

class ProspectProperty extends StateProperty {
  ProspectDataSource get _dataSource => Get.find<ProspectDataSource>(tag: ProspectString.prospectTag);

  Prospect? selectedProspect;

  Task task = Task(ProspectString.taskCode);

  void refresh() {
    _dataSource.fetchData();
    Get.find<TaskHelper>().loaderPush(task);
  }
}
