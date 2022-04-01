// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/navigators/schedule_navigator.dart';
import 'package:ventes/state_controllers/schedule_fc_state_controller.dart';
import 'package:ventes/views/regular_view.dart';
import 'package:ventes/widgets/regular_dropdown.dart';
import 'package:ventes/widgets/regular_select_box.dart';
import 'package:ventes/widgets/icon_input.dart';
import 'package:ventes/widgets/regular_input.dart';
import 'package:ventes/widgets/top_navigation.dart';

class ScheduleFormCreateView extends RegularView<ScheduleFormCreateStateController> {
  static const String route = "/schedule/create";
  ScheduleFormCreateView() {
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
        height: 85,
        title: "Schedule",
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
        actions: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: RegularSize.s,
              horizontal: RegularSize.m,
            ),
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
        below: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Form Create",
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
                height: RegularSize.l,
              ),
              Text(
                "General",
                style: TextStyle(
                  color: RegularColor.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: RegularSize.m,
              ),
              RegularInput(
                label: "Title",
                hintText: "Enter title",
              ),
              SizedBox(
                height: RegularSize.m,
              ),
              RegularSelectBox(
                label: "Type",
                onSelected: (value) {
                  $.typeActive = value;
                },
                activeIndex: $.typeActive,
                items: [
                  "Event",
                  "Task",
                  "Reminder",
                ],
              ),
              SizedBox(
                height: RegularSize.l,
              ),
              Text(
                "More Options",
                style: TextStyle(
                  color: RegularColor.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Expanded(
                child: Obx(() {
                  return Stack(
                    children: [
                      Offstage(
                        offstage: $.typeActive != 0,
                        child: _buildEventForm(),
                      )
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventForm() {
    return Column(
      children: [
        SizedBox(
          height: RegularSize.m,
        ),
        IconInput(
          icon: "assets/svg/history.svg",
          label: "Date",
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Row(
          children: [
            Obx(() {
              return Expanded(
                child: RegularDropdown<String?>(
                  label: "Time Start",
                  controller: $.timeStartSelectController,
                  items: $.timeStartList,
                  onSelected: (value) {
                    $.createStartTimeList();
                    print($.timeStartSelectController.value);
                  },
                ),
              );
            }),
            SizedBox(
              width: RegularSize.s,
            ),
            Obx(() {
              return Expanded(
                child: RegularDropdown<String?>(
                  label: "Time End",
                  controller: $.timeEndSelectController,
                  items: $.timeEndList,
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
