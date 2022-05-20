// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/keyable_selectbar.dart';
import 'package:ventes/app/resources/widgets/regular_date_picker.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/core/view.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';

class ProspectView extends View<ProspectStateController> {
  static const String route = "/history";
  ProspectView() {
    state = controller;
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
        title: "Prospect",
        appBarKey: state.appBarKey,
      ).build(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () {
              return Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: state.minHeight,
                ),
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
                      height: RegularSize.l,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: RegularSize.m),
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              return GestureDetector(
                                onTap: () {
                                  RegularDatePicker(
                                    onSelected: state.listener.onDateStartSelected,
                                    initialdate: state.formSource.prosstartdate,
                                  ).show();
                                },
                                child: IconInput(
                                  icon: "assets/svg/calendar.svg",
                                  label: "Start Date",
                                  enabled: false,
                                  value: state.formSource.prosstartdateString,
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: RegularSize.s),
                          Expanded(
                            child: Obx(() {
                              return GestureDetector(
                                onTap: () {
                                  RegularDatePicker(
                                    onSelected: state.listener.onDateEndSelected,
                                    initialdate: state.formSource.prosenddate,
                                    minDate: state.formSource.prosstartdate,
                                  ).show();
                                },
                                child: IconInput(
                                  icon: "assets/svg/calendar.svg",
                                  label: "End Date",
                                  enabled: false,
                                  value: state.formSource.prosenddateString,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: RegularSize.m,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: RegularSize.m),
                      child: KeyableSelectBar<int>(
                        height: RegularSize.xl,
                        label: "Follow Up Type",
                        items: {
                          0: "By Phone",
                          1: "By Email",
                          2: "On Site",
                          3: "Other Type",
                          4: "Another other type",
                        },
                        activeIndex: 0,
                        onSelected: (int index) {
                          print(index);
                        },
                      ),
                    ),
                    SizedBox(
                      height: RegularSize.m,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: RegularSize.m),
                      child: IconInput(
                        icon: "assets/svg/search.svg",
                        hintText: "Search",
                      ),
                    ),
                    SizedBox(
                      height: RegularSize.m,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: RegularSize.m),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Prospect List",
                        style: TextStyle(
                          fontSize: 20,
                          color: RegularColor.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
