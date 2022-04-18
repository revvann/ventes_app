// ignore_for_file: prefer_const_constructors

part of "package:ventes/app/resources/views/daily_schedule/daily_schedule.dart";

class _Calendar extends StatelessWidget {
  _Calendar({
    required this.date,
    this.appointmentBuilder,
    this.dataSource,
  });
  Widget Function(BuildContext, CalendarAppointmentDetails)? appointmentBuilder;
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
      allowAppointmentResize: true,
      onTap: (details) {},
      appointmentBuilder: appointmentBuilder,
      timeSlotViewSettings: TimeSlotViewSettings(
        timeIntervalHeight: 120,
      ),
    );
  }
}
