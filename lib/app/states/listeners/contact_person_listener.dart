import 'package:get/get.dart';
import 'package:ventes/app/resources/views/contact_form/create/contact_person_fc.dart';
import 'package:ventes/app/resources/views/contact_form/update/contact_person_fu.dart';
import 'package:ventes/app/states/typedefs/contact_person_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ContactPersonListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void onAddButtonClicked() {
    Get.toNamed(
      ContactPersonFormCreateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'customer': property.customerid,
      },
    );
  }

  void navigateToUpdateForm(int contactid) {
    Get.toNamed(
      ContactPersonFormUpdateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'contact': contactid,
      },
    );
  }

  void deleteData(int id) {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ProspectString.deleteContactConfirm,
        onFinished: (res) {
          if (res) {
            dataSource.deleteHandler.fetcher.run(id);
          }
        },
      ),
    );
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
