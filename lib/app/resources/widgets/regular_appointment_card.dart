// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide MenuItem;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/api/models/schedule_model.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/utils/utils.dart';

class RegularAppointmentCard extends StatelessWidget {
  RegularAppointmentCard({
    required this.schedule,
    this.primary = RegularColor.primary,
    this.isSelected = false,
  });
  Schedule schedule;
  Color primary;
  bool isSelected;

  bool isSmall() {
    int start = Utils.parseTime(schedule.schestarttime ?? "00:00:00").millisecondsSinceEpoch;
    int end = Utils.parseTime(schedule.scheendtime ?? "00:00:00").millisecondsSinceEpoch;
    return (end - start) <= 15 * 60 * 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primary,
        borderRadius: !isSelected ? BorderRadius.circular(RegularSize.s) : BorderRadius.circular(3),
      ),
      padding: !isSmall() ? EdgeInsets.all(RegularSize.xs) : EdgeInsets.only(top: 2, left: RegularSize.s, right: RegularSize.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            schedule.schenm ?? "",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: !isSmall() ? 12 : 10,
            ),
          ),
          if (!(schedule.scheallday ?? false))
            RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: !isSmall() ? 12 : 10,
                  color: Colors.white,
                ),
                children: [
                  if (schedule.schestarttime != null)
                    TextSpan(
                      text: Utils.formatTime12(Utils.parseTime(schedule.schestarttime!)),
                    ),
                  if (schedule.scheendtime != null)
                    TextSpan(
                      text: " - ",
                    ),
                  if (schedule.scheendtime != null)
                    TextSpan(
                      text: Utils.formatTime12(Utils.parseTime(schedule.scheendtime!)),
                    ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class RegularCalendarDataSource extends CalendarDataSource<Schedule> {
  RegularCalendarDataSource(
    List<Schedule> source, {
    this.type = CalendarDataSourceType.monthly,
    this.date,
  }) {
    appointments = source;
  }
  CalendarDataSourceType type;
  DateTime? date;

  @override
  DateTime getStartTime(int index) {
    String? date = appointments![index].schestartdate;
    String? time = appointments![index].schestarttime;
    if (date != null && time != null) {
      switch (type) {
        case CalendarDataSourceType.monthly:
          return Utils.dbParseDate(date);
        case CalendarDataSourceType.daily:
          DateTime _time = Utils.parseTime(time);
          return DateTime(this.date!.year, this.date!.month, this.date!.day, _time.hour, _time.minute);
        default:
          return Utils.dbParseDate(date);
      }
    }

    if (isAllDay(index)) {
      return Utils.dbParseDate(date!);
    }

    return DateTime(0);
  }

  @override
  DateTime getEndTime(int index) {
    String? date = appointments![index].scheenddate;
    String? time = appointments![index].scheendtime;
    if (date != null && time != null) {
      switch (type) {
        case CalendarDataSourceType.monthly:
          return Utils.dbParseDate(date);
        case CalendarDataSourceType.daily:
          DateTime _time = Utils.parseTime(time);
          return DateTime(this.date!.year, this.date!.month, this.date!.day, _time.hour, _time.minute);
        default:
          return Utils.dbParseDate(date);
      }
    }

    if (isAllDay(index)) {
      return getStartTime(index).add(Duration(hours: 23, minutes: 59));
    }

    return getStartTime(index).add(Duration(minutes: 15));
  }

  @override
  String getSubject(int index) {
    return appointments![index].schetoward.userfullname;
  }

  @override
  Color getColor(int index) {
    return RegularColor.primary;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].scheallday ?? false;
  }
}

enum CalendarDataSourceType { daily, monthly }
