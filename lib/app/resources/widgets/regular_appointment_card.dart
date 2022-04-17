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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RegularColor.primary,
        borderRadius: BorderRadius.circular(RegularSize.s),
      ),
      padding: EdgeInsets.all(RegularSize.xs),
      child: Text(
        schedule.schenm ?? "",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}

class RegularCalendarDataSource extends CalendarDataSource<Schedule> {
  RegularCalendarDataSource(List<Schedule> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return parseDate(appointments![index].schestartdate!);
  }

  @override
  DateTime getEndTime(int index) {
    return parseDate(appointments![index].scheenddate!);
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
    return appointments![index].scheallday;
  }
}
