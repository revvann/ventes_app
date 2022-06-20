import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/contact_person_fc_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonFormCreateProperty extends StateProperty with PropertyMixin {
  late int customerid;
  Task task = Task(ProspectString.formCreateContactTaskCode);

  void refresh() {
    dataSource.fetchData(customerid);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
