// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/editor_input.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_date_picker.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/prospect_detail_fc_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/view.dart';

class ProspectDetailFormCreateView extends View<ProspectDetailFormCreateStateController> {
  static const String route = "/prospect/detail/create";

  ProspectDetailFormCreateView(int prospectId) {
    state.properties.prospectId = prospectId;
  }

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
        title: ProspectString.appBarTitle,
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
            onTap: state.listener.onSubmitButtonClicked,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: RegularSize.s,
                horizontal: RegularSize.m,
              ),
              child: Text(
                ProspectString.submitButtonText,
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
                    key: state.formSource.formKey,
                    child: Column(
                      children: [
                        Obx(() {
                          return KeyableDropdown<int, DBType>(
                            controller: state.formSource.categoryDropdownController,
                            nullable: false,
                            child: Obx(
                              () {
                                return RegularInput(
                                  enabled: false,
                                  label: "Category",
                                  value: state.formSource.prosdtcategory?.typename,
                                  hintText: "Select category",
                                );
                              },
                            ),
                            onChange: state.listener.onCategorySelected,
                            items: state.dataSource.categoryItems,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.value.typename ?? "",
                                      style: TextStyle(
                                        color: isSelected ? RegularColor.green : RegularColor.dark,
                                        fontSize: 14,
                                      ),
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
                        Obx(() {
                          return KeyableDropdown<int, DBType>(
                            controller: state.formSource.typeDropdownController,
                            nullable: false,
                            child: Obx(
                              () {
                                return RegularInput(
                                  enabled: false,
                                  label: "Detail Type",
                                  value: state.formSource.prosdttype?.typename,
                                  hintText: "Select type",
                                );
                              },
                            ),
                            onChange: state.listener.onTypeSelected,
                            items: state.dataSource.typeItems,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.value.typename ?? "",
                                      style: TextStyle(
                                        color: isSelected ? RegularColor.green : RegularColor.dark,
                                        fontSize: 14,
                                      ),
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
                        GestureDetector(
                          onTap: () {
                            RegularDatePicker(
                              onSelected: state.listener.onDateSelected,
                              displaydate: state.formSource.date,
                              initialdate: state.formSource.date,
                            ).show();
                          },
                          child: Obx(() {
                            return IconInput(
                              icon: "assets/svg/calendar.svg",
                              label: "Date",
                              enabled: false,
                              hintText: "Choose Date",
                              value: state.formSource.dateString,
                              validator: state.formSource.validator.prosdtdate,
                            );
                          }),
                        ),
                        SizedBox(
                          height: RegularSize.m,
                        ),
                        EditorInput(
                          label: "Description",
                          hintText: "Enter description",
                          validator: state.formSource.validator.prosdtdesc,
                        ),
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
