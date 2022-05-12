// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/app/states/controllers/started_page_state_controller.dart';
import 'package:ventes/core/view.dart';
import 'package:ventes/app/resources/views/signin/signin.dart';

class StartedPageView extends View<StartedPageStateController> {
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
                  carouselController: state.carouselController,
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      state.activeIndex = index;
                      state.setIndicator(index);
                    },
                    height: Get.height * 0.6,
                    viewportFraction: 1,
                  ),
                  items: _buildCarouselList(),
                ),
              ),
              SizedBox(
                height: RegularSize.m,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIndicator(
                    0,
                    state.indicatorController1,
                    state.indicator1,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  _buildIndicator(
                    1,
                    state.indicatorController2,
                    state.indicator2,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  _buildIndicator(
                    2,
                    state.indicatorController3,
                    state.indicator3,
                  ),
                ],
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.toNamed(SigninView.route);
                    },
                    child: Text("Skip"),
                    style: TextButton.styleFrom(
                      primary: RegularColor.gray,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (state.activeIndex != 2) {
                        state.movePage(state.activeIndex + 1);
                      } else {
                        Get.toNamed(SigninView.route);
                      }
                    },
                    child: Obx(() {
                      return Text(state.activeIndex != 2 ? "Next" : "Start");
                    }),
                    style: TextButton.styleFrom(
                      primary: RegularColor.secondary,
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

  List<Widget>? _buildCarouselList() {
    return state.carouselData.map((i) {
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
                    color: RegularColor.secondary,
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
                      color: RegularColor.gray,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildIndicator(
    int index,
    AnimationController controller,
    Animation<MultiTweenValues<String>> animation,
  ) {
    return GestureDetector(
      onTap: () {
        state.movePage(index);
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) => Container(
          width: animation.value.get("width"),
          height: 8,
          decoration: BoxDecoration(
            color: RegularColor.secondary.withAlpha(animation.value.get("opacity").toInt()),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
