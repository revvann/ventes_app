// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/resources/views/regular_view.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/resources/widgets/regular_appointment_card.dart';
import 'package:ventes/app/resources/widgets/regular_dialog.dart';
import 'package:ventes/app/resources/widgets/regular_outlined_button.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/state/controllers/schedule_state_controller.dart';

part 'package:ventes/app/resources/views/schedule/components/_appointment_item.dart';
part 'package:ventes/app/resources/views/schedule/components/_calendar.dart';
part 'package:ventes/app/resources/views/schedule/components/_month_cell.dart';

class ScheduleView extends RegularView<ScheduleStateController> {
  static const String route = "/schedule";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: ScheduleString.appBarTitle,
        appBarKey: state.appBarKey,
        height: 90,
        leading: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(RegularSize.xs),
            child: SvgPicture.asset(
              "assets/svg/arrow-left.svg",
              width: RegularSize.xl,
              color: Colors.white,
            ),
          ),
          onTap: backToDashboard,
        ),
        actions: [
          GestureDetector(
            onTap: state.listener.onDetailClick,
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
                onTap: state.listener.onCalendarBackwardClick,
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
                String date = DateFormat("MMMM, yyyy").format(state.properties.dateShown);
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
                onTap: state.listener.onCalendarForwardClick,
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
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
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
                      child: Obx(() {
                        return _Calendar(
                          appointmentDetailItemBuilder: (schedule) => _AppointmentItem(
                            appointment: schedule,
                            onFindColor: state.listener.onAppointmentFindColor,
                          ),
                          monthCellBuilder: (_, details) {
                            return Obx(() {
                              bool selected = details.date == state.properties.selectedDate;
                              bool thisMonth = details.date.month == state.properties.dateShown.month;
                              int appointmentsCount = details.appointments.length;

                              Color textColor = RegularColor.gray;
                              double fontSize = 14;

                              if (thisMonth) {
                                textColor = RegularColor.dark;
                              }

                              if (selected) {
                                textColor = Colors.white;
                                fontSize = 18;
                              }
                              return _MonthCell(
                                day: "${details.date.day}",
                                textColor: textColor,
                                fontSize: fontSize,
                                appointmentsCount: appointmentsCount,
                                isSelected: selected,
                              );
                            });
                          },
                          dataSource: RegularCalendarDataSource(state.properties.dataSource.appointments),
                          calendarController: state.properties.calendarController,
                          onSelectionChanged: state.listener.onDateSelectionChanged,
                          initialDate: state.properties.initialDate,
                        );
                      }),
                    ),
                    SizedBox(
                      height: RegularSize.s,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
