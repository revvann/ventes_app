import 'package:get/get.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/contact_person_fu_typedef.dart';

class ContactPersonFormUpdateProperty extends StateProperty {
  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.contactUpdateTag);

  Task task = Task(ProspectString.formUpdateContactTaskCode);

  late int contactid;
  void refresh() {
    _dataSource.fetchData(contactid);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
