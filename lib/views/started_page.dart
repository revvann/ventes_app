// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/state_controllers/started_page_state_controller.dart';
import 'package:ventes/views/regular_view.dart';

class StartedPageView extends RegularView<StartedPageStateController> {
  static const route = "/started-page";
  StartedPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(RegularSize.m),
          child: Column(
            children: [
              SizedBox(
                height: RegularSize.xl,
              ),
              SizedBox(
                child: CarouselSlider(
                  carouselController: $.carouselController,
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      $.activeIndex = index;
                      $.setIndicator(index);
                    },
                    height: Get.height * 0.6,
                    viewportFraction: 1,
                  ),
                  items: $.carouselData.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: Get.width,
                          height: double.infinity,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: RegularSize.xl),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/bg2.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  i['image'],
                                  width: Get.width * 0.80,
                                ),
                              ),
                              SizedBox(
                                height: RegularSize.xxl,
                              ),
                              Text(
                                i["title"],
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: RegularColor.dark_1,
                                ),
                              ),
                              SizedBox(
                                height: RegularSize.m,
                              ),
                              Container(
                                width: Get.width * 0.80,
                                alignment: Alignment.center,
                                child: Text(
                                  i["subtitle"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: RegularColor.gray_3,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: RegularSize.m,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      $.movePage(0);
                    },
                    child: AnimatedBuilder(
                      animation: $.indicatorController1,
                      builder: (_, __) => Container(
                        width: $.indicator1.value.get("width"),
                        height: 8,
                        decoration: BoxDecoration(
                          color: RegularColor.primary.withAlpha($.indicator1.value.get("opacity").toInt()),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      $.movePage(1);
                    },
                    child: AnimatedBuilder(
                      animation: $.indicatorController2,
                      builder: (_, __) => Container(
                        width: $.indicator2.value.get("width"),
                        height: 8,
                        decoration: BoxDecoration(
                          color: RegularColor.primary.withAlpha($.indicator2.value.get("opacity").toInt()),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      $.movePage(2);
                    },
                    child: AnimatedBuilder(
                      animation: $.indicatorController3,
                      builder: (_, __) => Container(
                        width: $.indicator3.value.get("width"),
                        height: 8,
                        decoration: BoxDecoration(
                          color: RegularColor.primary.withAlpha($.indicator3.value.get("opacity").toInt()),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text("Skip"),
                    style: TextButton.styleFrom(
                      primary: RegularColor.gray_3,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if ($.activeIndex != 2) {
                        $.movePage($.activeIndex + 1);
                      }
                    },
                    child: Obx(() {
                      return Text($.activeIndex != 2 ? "Next" : "Start");
                    }),
                    style: TextButton.styleFrom(
                      primary: RegularColor.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
