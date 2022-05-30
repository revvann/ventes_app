// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_detail_model.dart';
import 'package:ventes/app/resources/widgets/regular_dialog.dart';
import 'package:ventes/app/resources/widgets/regular_outlined_button.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/view.dart';
import 'package:ventes/helpers/function_helpers.dart';

part 'package:ventes/app/resources/views/prospect_detail/components/_floating_button.dart';

class ProspectDetailView extends View<ProspectDetailStateController> {
  static const String route = "/prospect/detail";

  ProspectDetailView(int prospectId) {
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
        height: 80,
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
        below: GestureDetector(
          onTap: showDetailDialog,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: RegularSize.xl,
            ),
            alignment: Alignment.center,
            child: Obx(() {
              return Text(
                state.dataSource.prospect?.prospectcust?.sbccstmname ?? "",
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
          onRefresh: state.listener.onRefresh,
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
                      Obx(() {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.dataSource.prospectDetails.length,
                          itemBuilder: (_, index) {
                            ProspectDetail _prospectDetail = state.dataSource.prospectDetails[index];
                            return GestureDetector(
                              onTap: () => state.listener.onProspectDetailClicked(_prospectDetail.prospectdtid!),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: RegularSize.m,
                                  horizontal: RegularSize.m,
                                ),
                                margin: EdgeInsets.only(
                                  bottom: RegularSize.m,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(RegularSize.m),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 4),
                                      blurRadius: 30,
                                      color: Color(0xFF0157E4).withOpacity(0.1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          formatDate(dbParseDate(_prospectDetail.prospectdtdate!)),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: RegularColor.dark,
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: RegularSize.s,
                                            vertical: RegularSize.xs,
                                          ),
                                          decoration: BoxDecoration(
                                            color: RegularColor.secondary,
                                            borderRadius: BorderRadius.circular(RegularSize.s),
                                          ),
                                          child: Text(
                                            _prospectDetail.prospectdttype?.typename ?? "",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: RegularSize.m,
                                    ),
                                    Text(
                                      _prospectDetail.prospectdtdesc ?? "",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: RegularColor.dark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      })
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
