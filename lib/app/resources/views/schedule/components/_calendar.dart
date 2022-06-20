// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/schedule/schedule.dart';

class _Calendar extends StatelessWidget {
  _Calendar({
    required this.appointmentDetailItemBuilder,
    required this.dataSource,
    this.onSelectionChanged,
    this.calendarController,
    this.initialDate,
    this.monthCellBuilder,
  });
  RegularCalendarDataSource dataSource;
  Widget Function(Schedule) appointmentDetailItemBuilder;
  void Function(CalendarSelectionDetails)? onSelectionChanged;
  CalendarController? calendarController;
  DateTime? initialDate;
  Widget Function(BuildContext, MonthCellDetails)? monthCellBuilder;

  ScheduleStateController get state => Get.find<ScheduleStateController>();

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      dataSource: dataSource,
      onTap: (calendarTapDetails) {
        List<Schedule> appointments = List<Schedule>.from(calendarTapDetails.appointments ?? []);
        showDetailDialog(appointments);
      },
      monthViewSettings: MonthViewSettings(
        dayFormat: DateFormat.ABBR_WEEKDAY,
        appointmentDisplayMode: MonthAppointmentDisplayMode.none,
      ),
      onSelectionChanged: onSelectionChanged,
      controller: calendarController,
      headerHeight: 0,
      view: CalendarView.month,
      initialSelectedDate: initialDate,
      selectionDecoration: BoxDecoration(),
      monthCellBuilder: monthCellBuilder,
    );
  }

  void showDetailDialog(List<Schedule> appointments) {
    RegularDialog(
      width: Get.width * 0.9,
      child: Column(
        children: [
          SizedBox(
            height: appointments.isEmpty ? 0 : 300,
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () => openScheduleDialog(appointments[index]),
                  child: appointmentDetailItemBuilder(appointments[index]),
                );
              },
            ),
          ),
          if (appointments.isEmpty)
            Text(
              "Oops, There is nothing here",
              style: TextStyle(
                color: RegularColor.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          SizedBox(
            height: RegularSize.m,
          ),
          Row(
            children: [
              Expanded(
                child: RegularOutlinedButton(
                  label: "Cancel",
                  primary: RegularColor.secondary,
                  height: RegularSize.xxl,
                  onPressed: () {
                    Get.close(1);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ).show();
  }

  void openScheduleDialog(Schedule schedule) {
    RegularDialog(
      width: Get.width * 0.9,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        vertical: RegularSize.m,
        horizontal: RegularSize.m,
      ),
      child: SingleChildScrollView(
        child: ScheduleDetail(schedule, state.dataSource.permissions),
      ),
    ).show();
  }
}
