// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/editor_input.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_date_picker.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/prospect_fc_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/view.dart';

class ProspectFormCreateView extends View<ProspectFormCreateStateController> {
  static const String route = "/prospect/create";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: "Prospect",
        appBarKey: state.appBarKey,
        leading: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(RegularSize.xs),
            child: SvgPicture.asset(
              "assets/svg/arrow-left.svg",
              width: RegularSize.xl,
              color: Colors.white,
            ),
          ),
          onTap: state.listener.goBack,
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
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
          ),
        ],
      ).build(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: Obx(
            () {
              return Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: state.minHeight,
                ),
                padding: EdgeInsets.only(
                  right: RegularSize.m,
                  left: RegularSize.m,
                  top: RegularSize.l,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(RegularSize.xl),
                    topRight: Radius.circular(RegularSize.xl),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      children: [
                        RegularInput(
                          label: "Name",
                          hintText: "Enter name",
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    RegularDatePicker(
                                      onSelected: state.listener.onDateStartSelected,
                                      displaydate: state.formSource.prosstartdate,
                                      initialdate: state.formSource.prosstartdate,
                                    ).show();
                                  },
                                  child: IconInput(
                                    icon: "assets/svg/calendar.svg",
                                    label: "Start Date",
                                    enabled: false,
                                    hintText: "Choose Date",
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
                                      displaydate: state.formSource.prosenddate,
                                      minDate: state.formSource.prosstartdate,
                                    ).show();
                                  },
                                  child: IconInput(
                                    icon: "assets/svg/calendar.svg",
                                    label: "End Date",
                                    hintText: "Choose Date",
                                    enabled: false,
                                    value: state.formSource.prosenddateString,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        RegularInput(
                          label: "Value",
                          hintText: "Enter value",
                          inputType: TextInputType.number,
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        Obx(
                          () {
                            return GestureDetector(
                              onTap: () {
                                RegularDatePicker(
                                  onSelected: state.listener.onExpDateEndSelected,
                                  initialdate: state.formSource.prosexpenddate,
                                  displaydate: state.formSource.prosexpenddate,
                                ).show();
                              },
                              child: IconInput(
                                icon: "assets/svg/calendar.svg",
                                label: "Expectation End Date",
                                hintText: "Choose Date",
                                enabled: false,
                                value: state.formSource.prosexpenddateString,
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        Obx(() {
                          return KeyableDropdown<int, UserDetail>(
                            controller: state.formSource.ownerDropdownController,
                            child: RegularInput(
                              enabled: false,
                              label: "Owner",
                              hintText: "Select user",
                            ),
                            onChange: (value) => print(value),
                            items: state.dataSource.users,
                            itemBuilder: (item, isSelected) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: RegularSize.s,
                                  vertical: RegularSize.s,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(RegularSize.s),
                                  color: isSelected ? RegularColor.green.withOpacity(0.3) : Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    if (!isSelected)
                                      Container(
                                        width: 30,
                                        height: 30,
                                        alignment: Alignment.center,
                                        child: Text(
                                          item.value.user?.userfullname?.substring(0, 2).toUpperCase() ?? "",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: RegularColor.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    SizedBox(
                                      width: RegularSize.s,
                                    ),
                                    Text(
                                      item.value.user?.userfullname ?? "",
                                      style: TextStyle(
                                        color: isSelected ? RegularColor.green : RegularColor.dark,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    if (isSelected)
                                      SvgPicture.asset(
                                        "assets/svg/check.svg",
                                        color: RegularColor.green,
                                        height: RegularSize.m,
                                        width: RegularSize.m,
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        EditorInput(
                          label: "Description",
                          hintText: "Enter description",
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        Obx(() {
                          return KeyableDropdown<int, BpCustomer>(
                            controller: state.formSource.customerDropdownController,
                            child: RegularInput(
                              enabled: false,
                              label: "Customer",
                              hintText: "Select customer",
                            ),
                            onChange: (value) => print(value),
                            items: state.dataSource.bpcustomers,
                            itemBuilder: (item, isSelected) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: RegularSize.s,
                                  vertical: RegularSize.s,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(RegularSize.s),
                                  color: isSelected ? RegularColor.green.withOpacity(0.3) : Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    if (!isSelected)
                                      Container(
                                        width: 30,
                                        height: 30,
                                        alignment: Alignment.center,
                                        child: Image.network(item.value.sbccstmpic!),
                                        decoration: BoxDecoration(
                                          color: RegularColor.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    SizedBox(
                                      width: RegularSize.s,
                                    ),
                                    Text(
                                      item.value.sbccstmname ?? "",
                                      style: TextStyle(
                                        color: isSelected ? RegularColor.green : RegularColor.dark,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    if (isSelected)
                                      SvgPicture.asset(
                                        "assets/svg/check.svg",
                                        color: RegularColor.green,
                                        height: RegularSize.m,
                                        width: RegularSize.m,
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
