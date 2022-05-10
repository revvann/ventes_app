// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/app/state/controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/core/regular_view.dart';

class BottomNavigation extends View<BottomNavigationStateController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: RegularColor.disable,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: BottomNavigationItem(
              icon: 'assets/svg/home.svg',
              title: "Home",
              view: Views.dashboard,
            ),
          ),
          Expanded(
            child: BottomNavigationItem(
              icon: 'assets/svg/marker.svg',
              title: "Nearby",
              view: Views.nearby,
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                width: RegularSize.xxl,
                height: RegularSize.xxl,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: RegularColor.primary,
                ),
                child: SvgPicture.asset(
                  'assets/svg/calendar.svg',
                  color: Colors.white,
                  width: RegularSize.l,
                ),
              ),
              onTap: () {
                state.currentIndex = Views.schedule;
              },
            ),
          ),
          Expanded(
            child: BottomNavigationItem(
              icon: 'assets/svg/history.svg',
              title: "History",
              view: Views.history,
            ),
          ),
          Expanded(
            child: BottomNavigationItem(
              icon: 'assets/svg/user.svg',
              title: "Settings",
              view: Views.settings,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavigationItem extends View<BottomNavigationStateController> {
  BottomNavigationItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.view,
  }) : super(key: key);
  String icon;
  String title;
  Views view;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.currentIndex = view;
      },
      child: Container(
        alignment: Alignment.center,
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                icon,
                color: RegularColor.primary,
                width: RegularSize.l,
              ),
              SizedBox(
                height: RegularSize.xs,
              ),
              if (state.currentIndex == view)
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: RegularColor.gray,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
