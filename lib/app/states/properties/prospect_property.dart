import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectProperty extends StateProperty {
  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.prospectTag);

  Prospect? selectedProspect;

  Task task = Task(ProspectString.taskCode);

  void refresh() {
    _dataSource.fetchData();
    Get.find<TaskHelper>().loaderPush(task);
  }
}
