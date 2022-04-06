// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/navigators/schedule_navigator.dart';
import 'package:ventes/state_controllers/daily_schedule_state_controller.dart';
import 'package:ventes/views/regular_view.dart';
import 'package:ventes/views/schedule_fc.dart';
import 'package:ventes/widgets/regular_appointment_card.dart';
import 'package:ventes/widgets/regular_fab.dart';
import 'package:ventes/widgets/top_navigation.dart';

class DailyScheduleView extends RegularView<DailyScheduleStateController> {
  static const String route = "/schedule/daily";
  DailyScheduleView() {
    $ = controller;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: "Schedule",
        height: 85,
        appBarKey: $.appBarKey,
        leading: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(RegularSize.xs),
            child: SvgPicture.asset(
              "assets/svg/arrow-left.svg",
              width: RegularSize.xl,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Get.back(id: ScheduleNavigator.id);
          },
        ),
        below: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "March 12, 2022",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ).build(context),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: RegularSize.m,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(RegularSize.xl),
              topRight: Radius.circular(RegularSize.xl),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: RegularSize.xl,
              ),
              Expanded(
                child: SfCalendar(
                  dataSource: RegularCalendarDataSource(getApp()),
                  headerHeight: 0,
                  view: CalendarView.day,
                  minDate: DateTime(2022, 4, 6, 0, 0),
                  maxDate: DateTime(2022, 4, 6, 23, 59),
                  viewHeaderHeight: 0,
                  allowAppointmentResize: true,
                  onTap: (details) {},
                  appointmentBuilder: (context, detail) {
                    return RegularAppointmentCard(appointment: detail.appointments.first);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(ScheduleFormCreateView.route, id: ScheduleNavigator.id);
        },
        backgroundColor: RegularColor.primary,
        child: SvgPicture.asset(
          'assets/svg/plus.svg',
          color: Colors.white,
          width: RegularSize.l,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  List<RegularAppointment> getApp() {
    List<RegularAppointment> appointments = [];
    for (int i = 0; i < 10; i++) {
      RegularAppointment appointment = RegularAppointment(
        startTime: DateTime(2022, 4, 6, 1).add(Duration(hours: 1 + i)),
        endTime: DateTime(2022, 4, 6, 1).add(
          Duration(
            hours: (1 + i) + 3,
          ),
        ),
        location: "headquarter of hydra, Germany",
        title: "Monitoring hydra activity",
        subtitle: "Ask to Johan Schmidt as Hydra Owner for what they working on.",
        type: "By Phone",
      );
      appointments.add(appointment);
    }

    return appointments;
  }
}
