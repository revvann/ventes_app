import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/contact_person_fu_typedef.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ContactPersonFormUpdateProperty extends StateProperty with PropertyMixin {
  Task task = Task(ProspectString.formUpdateContactTaskCode);
  late int contactid;

  void refresh() {
    dataSource.fetchData(contactid);
    Get.find<TaskHelper>().loaderPush(task);
  }

  @override
  void init() async {
    super.init();
    bool isContactPermissionGranted = await Permission.contacts.isGranted;
    bool isPermanentDenied = await Permission.contacts.isPermanentlyDenied;
    if (!isContactPermissionGranted && !isPermanentDenied) {
      bool result = await Permission.contacts.request().isGranted;
      if (!result) {
        Get.find<TaskHelper>().failedPush(
          task.copyWith(
            message: "Contact permission is required",
            onFinished: (res) {
              Get.back(id: ProspectNavigator.id);
            },
          ),
        );
      }
    }
  }
}
