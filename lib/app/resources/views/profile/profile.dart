// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/profile_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/core/view/view.dart';

part 'package:ventes/app/resources/views/profile/components/_profile_detail.dart';
part 'package:ventes/app/resources/views/profile/components/_profile_item.dart';
part 'package:ventes/app/resources/views/profile/components/_bp_detail.dart';

class ProfileView extends View<ProfileStateController> {
  static const String route = "/profile";

  @override
  Widget buildWidget(BuildContext context, state) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: "Profile",
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
      ).build(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => state.refreshStates(),
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              child: Obx(() {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "User Profile",
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
                      _ProfileDetail(),
                      SizedBox(
                        height: RegularSize.l,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Business Partner Profile",
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
                      _BpDetail(),
                    ],
                  ),
                );
              }),
            ),
          ]),
        ),
      ),
    );
  }
}
