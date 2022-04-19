import 'package:get/get.dart';
import 'package:ventes/app/resources/views/daily_schedule/daily_schedule.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';
import 'package:ventes/state_controllers/schedule_state_controller.dart';

class ScheduleListener {
  late ScheduleStateController $;
  ScheduleListener(this.$);

  void onDateShownChanged(String data) {
    if (data == 'displayDate') {
      if ($.calendarController.displayDate != null) {
        $.dateShown = $.calendarController.displayDate!;
      }
      $.dataSource.fetchSchedules($.dateShown.month);
      Loader().show();
    }
  }

  void onCalendarBackwardClick() {
    $.calendarController.backward?.call();
  }

  void onCalendarForwardClick() {
    $.calendarController.forward?.call();
  }

  void onDateSelectionChanged(details) {
    $.selectedDate = details.date!;
  }

  void onDetailClick() {
    Get.toNamed(
      DailyScheduleView.route,
      id: ScheduleNavigator.id,
      arguments: {
        "date": $.selectedDate,
      },
    );
  }
}
