// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/helpers/function_helpers.dart';

class RegularAppointmentCard extends StatelessWidget {
  Schedule schedule;
  RegularAppointmentCard({required this.schedule});

  bool isSmall() {
    int start = parseTime(schedule.schestarttime ?? "00:00:00").millisecondsSinceEpoch;
    int end = parseTime(schedule.scheendtime ?? "00:00:00").millisecondsSinceEpoch;
    return (end - start) <= 15 * 60 * 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RegularColor.primary,
        borderRadius: BorderRadius.circular(RegularSize.s),
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
                    text: formatTime12(parseTime(schedule.schestarttime!)),
                  ),
                if (schedule.scheendtime != null)
                  TextSpan(
                    text: " - ",
                  ),
                if (schedule.scheendtime != null)
                  TextSpan(
                    text: formatTime12(parseTime(schedule.scheendtime!)),
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
          return dbParseDate(date);
        case CalendarDataSourceType.daily:
          DateTime _time = parseTime(time);
          return DateTime(this.date!.year, this.date!.month, this.date!.day, _time.hour, _time.minute);
        default:
          return dbParseDate(date);
      }
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
          return dbParseDate(date);
        case CalendarDataSourceType.daily:
          DateTime _time = parseTime(time);
          return DateTime(this.date!.year, this.date!.month, this.date!.day, _time.hour, _time.minute);
        default:
          return dbParseDate(date);
      }
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
