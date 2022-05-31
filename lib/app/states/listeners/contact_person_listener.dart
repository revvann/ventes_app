import 'package:get/get.dart';
import 'package:ventes/app/resources/views/contact_form/create/contact_person_fc.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ContactPersonListener {
  ContactPersonProperties get _properties => Get.find<ContactPersonProperties>();

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  Future onRefresh() async {
    _properties.refresh();
  }

  void onAddButtonClicked() {
    Get.toNamed(
      ContactPersonFormCreateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'customer': _properties.customerid,
      },
    );
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.contactPersonTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.contactPersonTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.contactPersonTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.contactPersonTaskCode);
  }
}
