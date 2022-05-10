// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventes/app/resources/views/regular_view.dart';
import 'package:ventes/app/resources/widgets/bottom_navigation.dart';
import 'package:ventes/app/resources/widgets/customer_card.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/state/controllers/dashboard_state_controller.dart';

class DashboardView extends RegularView<DashboardStateController> {
  static const route = "/dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildAppBar(),
                    _buildTopPanel(),
                  ],
                ),
              ),
              SizedBox(
                height: 125,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: RegularSize.m,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _buildMenuItem(
                          RegularColor.purple,
                          "assets/svg/marker.svg",
                          "Nearby",
                          () => state.bottomNavigation.currentIndex = Views.nearby,
                        ),
                        SizedBox(
                          width: RegularSize.s,
                        ),
                        _buildMenuItem(
                          RegularColor.yellow,
                          "assets/svg/calendar.svg",
                          "Schedule",
                          () => state.bottomNavigation.currentIndex = Views.schedule,
                        ),
                        SizedBox(
                          width: RegularSize.s,
                        ),
                        _buildMenuItem(
                          RegularColor.cyan,
                          "assets/svg/attendance.svg",
                          "Attendance",
                          () {
                            Loader().show();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: RegularSize.s,
                    ),
                    Row(
                      children: [
                        _buildMenuItem(
                          RegularColor.pink,
                          "assets/svg/daily-visit.svg",
                          "Daily Visit",
                          () {},
                        ),
                        SizedBox(
                          width: RegularSize.s,
                        ),
                        _buildMenuItem(
                          RegularColor.red,
                          "assets/svg/history.svg",
                          "History",
                          () => state.bottomNavigation.currentIndex = Views.history,
                        ),
                        SizedBox(
                          width: RegularSize.s,
                        ),
                        _buildMenuItem(
                          RegularColor.gray,
                          "assets/svg/prospect.svg",
                          "Prospect",
                          () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: RegularSize.m,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: RegularSize.l,
                    ),
                    Text(
                      "Plan For You",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: RegularColor.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: RegularSize.m,
                    ),
                    _buildTitleHeader("Nearby Customers"),
                  ],
                ),
              ),
              Container(
                height: 250,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    double mRight = 0;
                    if (index == 9) {
                      mRight = 16;
                    }
                    return CustomerCard(
                      image: AssetImage('assets/images/dummybg.jpg'),
                      margin: EdgeInsets.only(
                        left: 16,
                        right: mRight,
                        top: 24,
                        bottom: 24,
                      ),
                      width: 220,
                      title: "Oscorp Idustries",
                      type: "Genetic Exploration",
                      radius: "320 M",
                      workTime: "08.00-16.00",
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: RegularSize.m,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTitleHeader("Upcoming Visit"),
                  ],
                ),
              ),
              Container(
                height: 250,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    double mRight = 0;
                    if (index == 9) {
                      mRight = 16;
                    }
                    return CustomerCard(
                      image: AssetImage('assets/images/dummybg.jpg'),
                      margin: EdgeInsets.only(
                        left: 16,
                        right: mRight,
                        top: 24,
                        bottom: 24,
                      ),
                      width: 220,
                      title: "Oscorp Idustries",
                      type: "Genetic Exploration",
                      radius: "320 M",
                      workTime: "08.00-16.00",
                    );
                  },
                ),
              ),
              SizedBox(
                height: RegularSize.xl,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: RegularSize.s,
          vertical: RegularSize.m,
        ),
        alignment: Alignment.topCenter,
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 75,
                ),
              ],
            ),
            PopupMenuButton<String>(
              elevation: 0.3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(RegularSize.m),
              ),
              padding: EdgeInsets.zero,
              child: Container(
                width: RegularSize.xxl,
                height: RegularSize.xxl,
                alignment: Alignment.center,
                child: Text(
                  "SS",
                  style: TextStyle(
                    color: RegularColor.cream,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: RegularColor.secondary,
                ),
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "edit",
                  child: Row(
                    children: [
                      Container(
                        width: RegularSize.xl,
                        height: RegularSize.xl,
                        alignment: Alignment.center,
                        child: Text(
                          "SS",
                          style: TextStyle(
                            color: RegularColor.cream,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: RegularColor.secondary,
                        ),
                      ),
                      SizedBox(
                        width: RegularSize.s,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Stephen Strange",
                            style: TextStyle(
                              fontSize: 14,
                              color: RegularColor.dark,
                            ),
                          ),
                          Text(
                            "Sales",
                            style: TextStyle(
                              fontSize: 12,
                              color: RegularColor.gray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: "delete",
                  child: Row(
                    children: [
                      Container(
                        width: RegularSize.xl,
                        height: RegularSize.xl,
                        alignment: Alignment.center,
                        child: Text(
                          "SS",
                          style: TextStyle(
                            color: RegularColor.cream,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: RegularColor.secondary,
                        ),
                      ),
                      SizedBox(
                        width: RegularSize.s,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Stephen Strange",
                            style: TextStyle(
                              fontSize: 14,
                              color: RegularColor.dark,
                            ),
                          ),
                          Text(
                            "Director",
                            style: TextStyle(
                              fontSize: 12,
                              color: RegularColor.gray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: RegularColor.primary,
        ),
      ),
    );
  }

  Widget _buildTopPanel() {
    return Positioned(
      top: 75,
      left: RegularSize.m,
      right: RegularSize.m,
      child: Container(
        height: 150,
        padding: EdgeInsets.all(
          RegularSize.m,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(RegularSize.m),
          border: Border.all(
            color: RegularColor.disable,
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 30,
              color: Color(0xFF0157E4).withOpacity(0.1),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "Norman Osborn",
              style: TextStyle(
                fontSize: 16,
                color: RegularColor.dark,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: RegularSize.xs,
            ),
            Text(
              "New York City, United States",
              style: TextStyle(
                color: RegularColor.dark,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: RegularSize.m,
            ),
            Row(
              children: [
                _buildTopPanelItem('assets/svg/marker.svg', "15", "Nearby"),
                _buildTopPanelItem('assets/svg/calendar.svg', "8", "Scheduled"),
                _buildTopPanelItem('assets/svg/time-check.svg', "3", "Done"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPanelItem(String icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  width: RegularSize.l,
                  color: RegularColor.primary,
                ),
                SizedBox(
                  width: RegularSize.s,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: RegularColor.dark,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: RegularSize.xs,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RegularColor.gray,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(Color color, String icon, String text, [Function()? onTap]) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(RegularSize.m),
            border: Border.all(
              color: RegularColor.disable,
            ),
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
            children: [
              Container(
                width: RegularSize.xxl,
                height: RegularSize.xxl,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  icon,
                  width: RegularSize.l,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: RegularSize.s,
              ),
              Text(
                text,
                style: TextStyle(
                  color: RegularColor.dark,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: RegularColor.dark,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "See All",
          style: TextStyle(
            color: RegularColor.secondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
