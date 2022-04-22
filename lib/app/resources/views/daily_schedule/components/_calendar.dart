// ignore_for_file: prefer_const_constructors

part of "package:ventes/app/resources/views/daily_schedule/daily_schedule.dart";

class _Calendar extends StatelessWidget {
  _Calendar({
    required this.date,
    this.dataSource,
    required this.onFindColor,
    this.onTap,
  });
  DailyScheduleStateController $ = Get.find<DailyScheduleStateController>();
  Color Function(Schedule appointment) onFindColor;
  void Function(CalendarTapDetails details)? onTap;
  RegularCalendarDataSource? dataSource;
  DateTime date;

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      dataSource: dataSource,
      headerHeight: 0,
      view: CalendarView.day,
      minDate: DateTime(date.year, date.month, date.day, 0, 0),
      maxDate: DateTime(date.year, date.month, date.day, 23, 59),
      viewHeaderHeight: 0,
      onTap: onCalendarTap,
      selectionDecoration: BoxDecoration(),
      appointmentBuilder: appointmentBuilder,
      timeSlotViewSettings: TimeSlotViewSettings(
        timeIntervalHeight: 120,
      ),
      allowDragAndDrop: true,
      dragAndDropSettings: DragAndDropSettings(
        allowNavigation: true,
        allowScroll: true,
        autoNavigateDelay: Duration(seconds: 1),
        indicatorTimeFormat: 'HH:mm a',
        showTimeIndicator: true,
      ),
    );
  }

  void onCalendarTap(CalendarTapDetails details) {
    onTap?.call(details);
  }

  Widget appointmentBuilder(context, details) {
    Color primary = onFindColor(details.appointments.first);
    return Obx(() {
      bool isActive = $.selectedAppointment?.scheid == details.appointments.first.scheid;
      return RegularAppointmentCard(
        schedule: details.appointments.first,
        primary: primary,
        isSelected: isActive,
      );
    });
  }
}
