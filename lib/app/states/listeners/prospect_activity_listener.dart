import 'package:get/get.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/resources/views/prospect_activity_form/create/prospect_activity_fc.dart';
import 'package:ventes/app/resources/views/prospect_activity_form/update/prospect_activity_fu.dart';
import 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';
import 'package:ventes/app/states/controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_activity_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectActivityListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: Views.prospect.index);
  }

  void navigateToProspectActivityForm() {
    Get.toNamed(
      ProspectActivityFormCreateView.route,
      id: Views.prospect.index,
      arguments: {
        'prospect': property.prospectId,
      },
    );
  }

  void navigateToScheduleForm() {
    property.menuController.toggleDropdown(close: true);
    DBType? refType = dataSource.activityRefType;
    if (refType != null) {
      Get.find<BottomNavigationStateController>().currentIndex = Views.schedule;
      Get.toNamed(
        ScheduleFormCreateView.route,
        id: Views.schedule.index,
        arguments: {
          'refTypeId': refType.typeid,
          'refData': {
            'prospectactivityprospectid': property.prospectId,
          },
        },
      );
    }
  }

  void onProspectActivityClicked(int id) {
    Get.toNamed(
      ProspectActivityFormUpdateView.route,
      id: Views.prospect.index,
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
