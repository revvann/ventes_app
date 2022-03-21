// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/state_controllers/splash_screen_state_controller.dart';
import 'package:ventes/views/regular_view.dart';

class SplashScreenView extends RegularView<SplashScreenStateController> {
  static const String route = "/welcome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: $.logoController,
                builder: (_, __) => Positioned(
                  right: $.logoPos.value,
                  child: Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: Text(
                      "VENTES",
                      style: TextStyle(
                        color: RegularColor.primary,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: $.bubbleController1,
                builder: (_, __) => Positioned(
                  left: $.bubblePos1.value.get("left"),
                  top: $.bubblePos1.value.get("top"),
                  child: Container(
                    width: 210,
                    height: 210,
                    decoration: BoxDecoration(
                      color: RegularColor.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: $.bubbleController2,
                builder: (_, __) => Positioned(
                  right: $.bubblePos2.value,
                  top: (Get.height / 2) - 210,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      color: RegularColor.yellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: $.bubbleController3,
                builder: (_, __) => Positioned(
                  left: $.bubblePos3.value,
                  top: (Get.height / 2) + 20,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: RegularColor.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: $.bubbleController4,
                builder: (_, __) => Positioned(
                  bottom: $.bubblePos4.value.get("bottom"),
                  right: $.bubblePos4.value.get("right"),
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      color: RegularColor.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
