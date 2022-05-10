// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/routing/navigators/dashboard_navigator.dart';
import 'package:ventes/state/controllers/contact_state_controller.dart';
import 'package:ventes/app/resources/views/regular_view.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/contact_card.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';

class ContactView extends RegularView<ContactStateController> {
  static const String route = "/contact";
  ContactView() {
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
        title: "Contact",
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
          onTap: () {
            Get.back(id: DashboardNavigator.id);
          },
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(RegularSize.xs),
            child: SvgPicture.asset(
              "assets/svg/filter.svg",
              width: RegularSize.l,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.all(RegularSize.xs),
            child: SvgPicture.asset(
              "assets/svg/plus-bold.svg",
              width: RegularSize.l,
              color: Colors.white,
            ),
          ),
        ],
      ).build(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: RegularSize.m,
                ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: RegularSize.m,
                    ),
                    IconInput(
                      icon: "assets/svg/search.svg",
                      hintText: "Search",
                    ),
                    SizedBox(
                      height: RegularSize.m,
                    ),
                    Text(
                      "Contacts List",
                      style: TextStyle(
                        fontSize: 20,
                        color: RegularColor.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: RegularSize.m,
                    ),
                    ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return ContactCard(
                          avatar: 'assets/images/dummyavatar.jpg',
                          name: "Christian Jono S.H",
                          job: "Security",
                          company: "Realless Corp.",
                        );
                      },
                    ),
                    SizedBox(
                      height: 75,
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
