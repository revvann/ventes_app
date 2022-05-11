// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:ventes/app/resources/views/started_page.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';

class SplashScreenStateController extends RegularStateController with GetTickerProviderStateMixin {
  @override
  bool get isFixedBody => false;

  late Animation<double> _logoPos;
  late AnimationController _logoController;
  late Animation<double> _bubblePos1;
  late AnimationController _bubbleController1;

  Animation<double> get logoPos => _logoPos;
  AnimationController get logoController => _logoController;
  Animation<double> get bubblePos1 => _bubblePos1;
  AnimationController get bubbleController1 => _bubbleController1;

  @override
  onInit() {
    super.onInit();
    _initAnimation();
  }

  Future _initAnimation() async {
    _logoController = AnimationController(vsync: this);
    _logoController.duration = Duration(milliseconds: 1500);
    Tween<double> _logoTween = Tween<double>(begin: -250, end: (Get.width / 2) - 100);
    _logoPos = _logoTween.animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOutCirc));

    _bubbleController1 = AnimationController(vsync: this);
    _bubbleController1.duration = Duration(milliseconds: 2000);
    Tween<double> _bubbleTween1 = Tween<double>(begin: 0, end: Get.height);
    _bubblePos1 = _bubbleTween1.animate(CurvedAnimation(parent: _bubbleController1, curve: Curves.easeOutCirc));

    await _logoController.forward();
    await Future.delayed(Duration(milliseconds: 300));
    await _bubbleController1.forward();
    await Future.delayed(Duration(milliseconds: 500));
    Get.offAndToNamed(StartedPageView.route);
  }
}
