// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/navigators/schedule_navigator.dart';
import 'package:ventes/state_controllers/schedule_state_controller.dart';
import 'package:ventes/views/daily_schedule.dart';
import 'package:ventes/views/regular_view.dart';
import 'package:ventes/widgets/regular_appointment_card.dart';
import 'package:ventes/widgets/regular_button.dart';
import 'package:ventes/widgets/regular_dialog.dart';
import 'package:ventes/widgets/regular_outlined_button.dart';
import 'package:ventes/widgets/regular_select_pill.dart';
import 'package:ventes/widgets/top_navigation.dart';

class ScheduleView extends RegularView<ScheduleStateController> {
  static const String route = "/schedule";
  ScheduleView() {
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
        appBarKey: $.appBarKey,
        height: 90,
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(DailyScheduleView.route, id: ScheduleNavigator.id);
            },
            child: Container(
              padding: EdgeInsets.all(RegularSize.xs),
              child: SvgPicture.asset(
                "assets/svg/detail.svg",
                width: RegularSize.l,
                color: Colors.white,
              ),
            ),
          ),
        ],
        below: Container(
          margin: EdgeInsets.only(
            top: RegularSize.s,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  $.calendarController.backward?.call();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/svg/arrow-left-sm.svg',
                    color: Colors.white,
                    width: RegularSize.l,
                  ),
                ),
              ),
              SizedBox(
                width: RegularSize.s,
              ),
              Obx(() {
                String date = DateFormat('MMMM yyyy').format($.dateShown);
                return Container(
                  width: Get.width * 0.5,
                  alignment: Alignment.center,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
              SizedBox(
                width: RegularSize.s,
              ),
              GestureDetector(
                onTap: () {
                  $.calendarController.forward?.call();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/svg/arrow-right-sm.svg',
                    color: Colors.white,
                    width: RegularSize.l,
                  ),
                ),
              ),
            ],
          ),
        ),
      ).build(context),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(RegularSize.xl),
              topRight: Radius.circular(RegularSize.xl),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: RegularSize.xl,
              ),
              Expanded(
                child: SfCalendar(
                  dataSource: RegularCalendarDataSource(getApp()),
                  onTap: (calendarTapDetails) {
                    List<RegularAppointment> appointments = List<RegularAppointment>.from(calendarTapDetails.appointments ?? []);
                    _showDialogDetail(appointments);
                  },
                  monthViewSettings: MonthViewSettings(
                    dayFormat: DateFormat.ABBR_WEEKDAY,
                    appointmentDisplayMode: MonthAppointmentDisplayMode.none,
                  ),
                  onSelectionChanged: (details) {
                    $.selectedDate = details.date!;
                  },
                  controller: $.calendarController,
                  headerHeight: 0,
                  view: CalendarView.month,
                  initialSelectedDate: $.selectedDate,
                  selectionDecoration: BoxDecoration(),
                  monthCellBuilder: (_, details) {
                    return Obx(() {
                      bool selected = details.date == $.selectedDate;
                      bool thisMonth = details.date.month == $.dateShown.month;

                      Color textColor = RegularColor.gray;
                      double fontSize = 14;

                      if (thisMonth) {
                        textColor = RegularColor.dark;
                      }

                      if (selected) {
                        textColor = Colors.white;
                        fontSize = 18;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: selected ? RegularColor.primary : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${details.date.day}",
                          style: TextStyle(
                            fontSize: fontSize,
                            color: textColor,
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilter() {
    RegularDialog(
      width: Get.width * 0.9,
      child: Column(
        children: [
          RegularSelectPill(
            label: "Visit Type",
            items: [
              RegularSelectPillItem(text: "On Site", value: "1"),
              RegularSelectPillItem(text: "By Phone", value: "2"),
            ],
            onSelected: (val) {
              print(val);
            },
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          RegularButton(
            label: "Apply",
            primary: RegularColor.secondary,
            height: RegularSize.xxl,
            onPressed: () {},
          ),
        ],
      ),
    ).show();
  }

  void _showDialogDetail(List<RegularAppointment> appointments) {
    RegularDialog(
      width: Get.width * 0.9,
      child: Column(
        children: [
          SizedBox(
            height: appointments.isEmpty ? 0 : 300,
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (_, index) {
                RegularAppointment appointment = appointments[index];
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: RegularSize.m,
                    vertical: RegularSize.s,
                  ),
                  margin: EdgeInsets.only(bottom: RegularSize.s),
                  decoration: BoxDecoration(
                    color: Color(0xffEFF5EF),
                    borderRadius: BorderRadius.circular(RegularSize.m),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            appointment.title,
                            style: TextStyle(
                              color: Color(0xffADC2AD),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: RegularSize.s,
                              vertical: RegularSize.xs,
                            ),
                            child: Text(
                              appointment.type,
                              style: TextStyle(
                                color: RegularColor.gray,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (appointment.location != null)
                        Text(
                          appointment.location!,
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xffADC2AD),
                            fontSize: 10,
                          ),
                        ),
                      SizedBox(
                        height: RegularSize.xs,
                      ),
                      Text(
                        appointment.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xffADC2AD),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
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
              SizedBox(
                width: RegularSize.s,
              ),
              Expanded(
                child: RegularButton(
                  label: "Detail",
                  primary: RegularColor.secondary,
                  height: RegularSize.xxl,
                  onPressed: () {
                    Get.close(1);
                    Get.toNamed(DailyScheduleView.route, id: ScheduleNavigator.id);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ).show();
  }

  List<RegularAppointment> getApp() {
    List<RegularAppointment> appointments = [];
    for (int i = 0; i < 5; i++) {
      RegularAppointment appointment = RegularAppointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(
          Duration(
            hours: 3,
            minutes: 45,
          ),
        ),
        location: "Lawrence, Massachusetts, USA",
        title: "Visit Essex Corporation",
        subtitle: "Watch how essex corp do their job as mutant genetic experiment.",
        type: "On Site",
      );
      appointments.add(appointment);
    }
    return appointments;
  }
}
