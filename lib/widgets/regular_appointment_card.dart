// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class RegularAppointmentCard extends StatelessWidget {
  RegularAppointment appointment;
  RegularAppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RegularColor.primary,
        borderRadius: BorderRadius.circular(RegularSize.s),
      ),
      padding: EdgeInsets.all(RegularSize.xs),
      child: Text(
        appointment.title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}

class RegularCalendarDataSource extends CalendarDataSource<RegularAppointment> {
  RegularCalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class RegularAppointment extends Appointment {
  String type;
  String title;
  String subtitle;
  RegularAppointment({
    required DateTime endTime,
    required DateTime startTime,
    required this.subtitle,
    required this.title,
    required String location,
    required this.type,
  }) : super(
          endTime: endTime,
          startTime: startTime,
          notes: subtitle,
          subject: title,
          location: location,
          color: RegularColor.primary,
        );
}
