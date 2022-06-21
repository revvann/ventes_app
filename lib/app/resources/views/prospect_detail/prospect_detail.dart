// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_detail_model.dart';
import 'package:ventes/app/resources/widgets/pop_up_item.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/app/resources/widgets/prospect_detail_dialog.dart';
import 'package:ventes/app/resources/widgets/regular_dialog.dart';
import 'package:ventes/app/resources/widgets/regular_outlined_button.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_typedef.dart';
import 'package:ventes/constants/gestures/copy_gesture_recognizer.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/view/view.dart';
import 'package:ventes/helpers/function_helpers.dart';

part 'package:ventes/app/resources/views/prospect_detail/components/_floating_button.dart';
part 'package:ventes/app/resources/views/prospect_detail/components/_detail_list.dart';
part 'package:ventes/app/resources/views/prospect_detail/components/_app_bar_menu.dart';
part 'package:ventes/app/resources/views/prospect_detail/components/_detail_dialog.dart';

class ProspectDetailView extends View<Controller> {
  static const String route = "/prospect/detail";
  int prospectId;

  ProspectDetailView(this.prospectId);

  @override
  void onBuild(state) {
    state.property.prospectId = prospectId;
  }

  @override
  Widget buildWidget(BuildContext context, state) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: ProspectString.appBarTitle,
        height: 80,
        appBarKey: state.appBarKey,
        onTitleTap: () async => state.refreshStates(),
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
          _AppBarMenu(),
          SizedBox(width: RegularSize.s),
        ],
        below: GestureDetector(
          onTap: showDetailDialog,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: RegularSize.xl,
            ),
            alignment: Alignment.center,
            child: Obx(() {
              return Text(
                state.dataSource.prospect?.prospectname ?? "",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              );
            }),
          ),
        ),
      ).build(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => state.refreshStates(),
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
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Prospect Details",
                          style: TextStyle(
                            color: RegularColor.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: RegularSize.m,
                      ),
                      _DetailList(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: _FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void showDetailDialog() {
    RegularDialog(
      width: Get.width * 0.9,
      child: Column(
        children: [
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
          RegularOutlinedButton(
            label: "Cancel",
            primary: RegularColor.secondary,
            height: RegularSize.xxl,
            onPressed: () {
              Get.close(1);
            },
          ),
        ],
      ),
    ).show();
  }
}
