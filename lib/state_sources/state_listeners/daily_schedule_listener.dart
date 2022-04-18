import 'package:get/get.dart';
import 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/state_controllers/daily_schedule_state_controller.dart';

class DailyScheduleListener {
  DailyScheduleListener($);
  late DailyScheduleStateController $;

  void onArrowBackClick() {
    Get.back(id: ScheduleNavigator.id);
  }

  void onAddButtonClick() {
    Get.toNamed(ScheduleFormCreateView.route, id: ScheduleNavigator.id);
  }
}
