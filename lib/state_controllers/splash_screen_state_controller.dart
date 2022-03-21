// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:ventes/views/started_page.dart';

class SplashScreenStateController extends GetxController with GetTickerProviderStateMixin {
  late Animation<double> _logoPos;
  late AnimationController _logoController;
  late Animation<MultiTweenValues<String>> _bubblePos1;
  late AnimationController _bubbleController1;
  late Animation<MultiTweenValues<String>> _bubblePos4;
  late AnimationController _bubbleController4;
  late Animation<double> _bubblePos2;
  late AnimationController _bubbleController2;
  late Animation<double> _bubblePos3;
  late AnimationController _bubbleController3;

  Animation<double> get logoPos => _logoPos;
  AnimationController get logoController => _logoController;
  Animation<MultiTweenValues<String>> get bubblePos1 => _bubblePos1;
  AnimationController get bubbleController1 => _bubbleController1;
  Animation<MultiTweenValues<String>> get bubblePos4 => _bubblePos4;
  AnimationController get bubbleController4 => _bubbleController4;
  Animation<double> get bubblePos2 => _bubblePos2;
  AnimationController get bubbleController2 => _bubbleController2;
  Animation<double> get bubblePos3 => _bubblePos3;
  AnimationController get bubbleController3 => _bubbleController3;

  @override
  onInit() {
    super.onInit();
    _initAnimation();
  }

  Future _initAnimation() async {
    _logoController = AnimationController(vsync: this);
    _logoController.duration = Duration(milliseconds: 1200);
    Tween<double> _logoTween = Tween<double>(begin: -250, end: (Get.width / 2) - 100);
    _logoPos = _logoTween.animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOutCirc));

    _bubbleController1 = AnimationController(vsync: this);
    _bubbleController1.duration = Duration(milliseconds: 1500);
    MultiTween<String> _bubbleTween1 = MultiTween<String>()
      ..add("left", Tween<double>(begin: -230, end: -60))
      ..add("top", Tween<double>(begin: -230, end: -100));
    _bubblePos1 = _bubbleTween1.animate(CurvedAnimation(parent: _bubbleController1, curve: Curves.easeOutCirc));

    _bubbleController2 = AnimationController(vsync: this);
    _bubbleController2.duration = Duration(milliseconds: 1500);
    Tween<double> _bubbleTween2 = Tween<double>(begin: -190, end: -130);
    _bubblePos2 = _bubbleTween2.animate(CurvedAnimation(parent: _bubbleController2, curve: Curves.easeOutCirc));

    _bubbleController3 = AnimationController(vsync: this);
    _bubbleController3.duration = Duration(milliseconds: 1500);
    Tween<double> _bubbleTween3 = Tween<double>(begin: -170, end: -120);
    _bubblePos3 = _bubbleTween3.animate(CurvedAnimation(parent: _bubbleController3, curve: Curves.easeOutCirc));

    _bubbleController4 = AnimationController(vsync: this);
    _bubbleController4.duration = Duration(milliseconds: 1500);
    MultiTween<String> _bubbleTween4 = MultiTween<String>()
      ..add("right", Tween<double>(begin: -210, end: -120))
      ..add("bottom", Tween<double>(begin: -210, end: -90));
    _bubblePos4 = _bubbleTween4.animate(CurvedAnimation(parent: _bubbleController4, curve: Curves.easeOutCirc));

    await _logoController.forward();
    await Future.delayed(Duration(milliseconds: 300));
    _bubbleController1.forward();
    _bubbleController2.forward();
    _bubbleController3.forward();
    await _bubbleController4.forward();
    await Future.delayed(Duration(milliseconds: 500));
    Get.offAndToNamed(StartedPageView.route);
  }
}
