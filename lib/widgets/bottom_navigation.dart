// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/state_controllers/bottom_navigation_state_controller.dart';
import 'package:ventes/views/regular_view.dart';

class BottomNavigation extends RegularView<BottomNavigationStateController> {
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
          BottomNavigationItem(
            icon: 'assets/svg/home.svg',
            title: "Home",
            view: Views.dashboard,
          ),
          BottomNavigationItem(
            icon: 'assets/svg/marker.svg',
            title: "Nearby",
            view: Views.nearby,
          ),
          SizedBox(),
          BottomNavigationItem(
            icon: 'assets/svg/history.svg',
            title: "History",
            view: Views.history,
          ),
          BottomNavigationItem(
            icon: 'assets/svg/user.svg',
            title: "Settings",
            view: Views.settings,
          ),
        ],
      ),
    );
  }
}

class BottomNavigationItem extends RegularView<BottomNavigationStateController> {
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
        child: Column(
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
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: RegularColor.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
