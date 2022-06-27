import 'package:get/get.dart';
import 'package:ventes/app/resources/views/prospect_activity_form/create/prospect_activity_fc.dart';
import 'package:ventes/app/resources/views/prospect_activity_form/update/prospect_activity_fu.dart';
import 'package:ventes/app/states/typedefs/prospect_activity_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectActivityListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void navigateToProspectActivityForm() {
    Get.toNamed(
      ProspectActivityFormCreateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': property.prospectId,
      },
    );
  }

  void onProspectActivityClicked(int id) {
    Get.toNamed(
      ProspectActivityFormUpdateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospectactivity': id,
      },
    );
  }

  void deleteDetail(int id) {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ProspectString.deleteDetailConfirm,
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
