// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/state_controllers/main_state_controller.dart';
import 'package:ventes/views/contact.dart';
import 'package:ventes/views/customer.dart';
import 'package:ventes/views/regular_view.dart';
import 'package:ventes/widgets/bottom_navigation.dart';
import 'package:ventes/widgets/customer_card.dart';

class MainView extends RegularView<MainStateController> {
  static const route = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        _buildMenuItem(RegularColor.purple, "assets/svg/marker.svg", "Nearby"),
                        SizedBox(
                          width: RegularSize.s,
                        ),
                        _buildMenuItem(RegularColor.yellow, "assets/svg/calendar.svg", "Schedule"),
                        SizedBox(
                          width: RegularSize.s,
                        ),
                        _buildMenuItem(
                          RegularColor.cyan,
                          "assets/svg/building.svg",
                          "Customer",
                          () {
                            Get.toNamed(CustomerView.route);
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
                          "assets/svg/contact.svg",
                          "Contact",
                          () => Get.toNamed(ContactView.route),
                        ),
                        SizedBox(
                          width: RegularSize.s,
                        ),
                        _buildMenuItem(RegularColor.red, "assets/svg/history.svg", "History"),
                        SizedBox(
                          width: RegularSize.s,
                        ),
                        _buildMenuItem(RegularColor.gray, "assets/svg/settings.svg", "Settings"),
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
                      title: "PT. Ibu dan Anak",
                      type: "Manufacture Industry",
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
                      title: "PT. Ibu dan Anak",
                      type: "Manufacture Industry",
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
      bottomNavigationBar: BottomNavigation(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Get.toNamed("/scan");
        },
        splashColor: null,
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: RegularColor.primary,
            ),
            child: SvgPicture.asset(
              'assets/svg/plus.svg',
              color: Colors.white,
              width: RegularSize.l,
            ),
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
                  width: RegularSize.xxl,
                ),
                SizedBox(
                  width: RegularSize.s,
                ),
                RichText(
                  text: TextSpan(
                    text: "VENTES \n",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 20,
                      color: RegularColor.dark.withAlpha(200),
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "APP",
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: RegularSize.xxl,
              height: RegularSize.xxl,
              alignment: Alignment.center,
              child: Text(
                "RR",
                style: TextStyle(
                  color: RegularColor.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RegularColor.cream,
              ),
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
              "Risca Revan",
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
              "Periuk, Tangerang, Banten",
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
