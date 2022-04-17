import 'package:ventes/state_controllers/schedule_state_controller.dart';

class ScheduleListener {
  late ScheduleStateController $;
  ScheduleListener(this.$);

  void onDateShownChanged(String data) {
    if (data == 'displayDate') {
      if ($.calendarController.displayDate != null) {
        $.dateShown = $.calendarController.displayDate!;
      }
      $.dataSource.fetchSchedule();
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
}
