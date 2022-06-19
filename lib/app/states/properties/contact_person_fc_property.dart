import 'package:get/get.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/contact_person_fc_typedef.dart';

class ContactPersonFormCreateProperty extends StateProperty {
  late int customerid;

  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.contactCreateTag);

  Task task = Task(ProspectString.formCreateContactTaskCode);

  void refresh() {
    _dataSource.fetchData(customerid);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
