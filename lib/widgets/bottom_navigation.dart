// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

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
          ),
          BottomNavigationItem(
            icon: 'assets/svg/marker.svg',
            title: "Nearby",
          ),
          SizedBox(),
          BottomNavigationItem(
            icon: 'assets/svg/history.svg',
            title: "History",
          ),
          BottomNavigationItem(
            icon: 'assets/svg/user.svg',
            title: "Settings",
          ),
        ],
      ),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  BottomNavigationItem({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);
  String icon;
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
