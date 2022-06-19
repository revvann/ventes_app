import 'package:get/get.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_fu_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailFormUpdateProperty extends StateProperty {
  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.detailUpdateTag);

  late int prospectDetailId;

  Task task = Task(ProspectString.formUpdateDetailTaskCode);

  refresh() {
    _dataSource.fetchData(prospectDetailId);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
