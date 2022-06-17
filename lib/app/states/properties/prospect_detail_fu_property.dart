part of 'package:ventes/app/states/controllers/prospect_detail_fu_state_controller.dart';

class ProspectDetailFormUpdateProperty extends StateProperty {
  ProspectDetailFormUpdateDataSource get _dataSource => Get.find<ProspectDetailFormUpdateDataSource>(tag: ProspectString.detailUpdateTag);

  late int prospectDetailId;

  Task task = Task(ProspectString.formUpdateDetailTaskCode);

  refresh() {
    _dataSource.fetchData(prospectDetailId);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
