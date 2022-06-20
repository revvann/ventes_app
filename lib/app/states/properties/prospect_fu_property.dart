import 'package:get/get.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_fu_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectFormUpdateProperty extends StateProperty with PropertyMixin {
  late int prospectId;
  Task task = Task(ProspectString.formUpdateTaskCode);

  void refresh() {
    dataSource.fetchData(prospectId);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
