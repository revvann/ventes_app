// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';

class StartedPageStateController extends GetxController with GetTickerProviderStateMixin {
  final CarouselController _carouselController = CarouselController();
  late Animation<MultiTweenValues<String>> _indicator1;
  late Animation<MultiTweenValues<String>> _indicator2;
  late Animation<MultiTweenValues<String>> _indicator3;
  late AnimationController _indicatorController1;
  late AnimationController _indicatorController2;
  late AnimationController _indicatorController3;
  final _activeIndex = 0.obs;
  List<Map> get carouselData => [
        {
          "image": 'assets/svg/illustration1.svg',
          "title": "Work Anywhere",
          "subtitle": "Make your work easier. Ventes can help you manage your job everywhere.",
        },
        {
          "image": 'assets/svg/illustration2.svg',
          "title": "Make fun with data",
          "subtitle": "Want data report?, not a big problem. Ventes always makes statistics about your data.",
        },
        {
          "image": 'assets/svg/illustration3.svg',
          "title": "Solve complex problem",
          "subtitle": "There are no complex problem to solve, every problem has a solution.",
        },
      ];

  CarouselController get carouselController => _carouselController;
  Animation<MultiTweenValues<String>> get indicator1 => _indicator1;
  Animation<MultiTweenValues<String>> get indicator2 => _indicator2;
  Animation<MultiTweenValues<String>> get indicator3 => _indicator3;
  AnimationController get indicatorController1 => _indicatorController1;
  AnimationController get indicatorController2 => _indicatorController2;
  AnimationController get indicatorController3 => _indicatorController3;

  int get activeIndex => _activeIndex.value;
  set activeIndex(int value) => _activeIndex.value = value;

  @override
  void onInit() {
    super.onInit();
    _indicatorController1 = AnimationController(vsync: this);
    _indicatorController1.duration = Duration(milliseconds: 300);
    _indicatorController2 = AnimationController(vsync: this);
    _indicatorController2.duration = Duration(milliseconds: 300);
    _indicatorController3 = AnimationController(vsync: this);
    _indicatorController3.duration = Duration(milliseconds: 300);

    MultiTween<String> tweens = MultiTween<String>()
      ..add("width", Tween<double>(begin: 8, end: 20))
      ..add("opacity", Tween<double>(begin: 120, end: 255));

    _indicator1 = tweens.animate(_indicatorController1);
    _indicator2 = tweens.animate(_indicatorController2);
    _indicator3 = tweens.animate(_indicatorController3);
    _indicatorController1.forward();
  }

  void movePage(int index) {
    _carouselController.animateToPage(index);
    setIndicator(index);
  }

  void setIndicator(int index) {
    _indicatorController1.reverse();
    _indicatorController2.reverse();
    _indicatorController3.reverse();
    switch (index) {
      case 0:
        _indicatorController1.forward();
        break;
      case 1:
        _indicatorController2.forward();
        break;
      case 2:
        _indicatorController3.forward();
        break;
    }
  }
}
