// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/states/controllers/splash_screen_state_controller.dart';
import 'package:ventes/core/view.dart';

class SplashScreenView extends View<SplashScreenStateController> {
  static const String route = "/welcome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildDownScreen(),
              _buildLogo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownScreen() {
    return AnimatedBuilder(
      animation: state.bubbleController1,
      builder: (_, __) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          height: state.bubblePos1.value,
          decoration: BoxDecoration(
            color: RegularColor.secondary,
            // shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: state.logoController,
      builder: (_, __) => Positioned(
        right: state.logoPos.value,
        child: Container(
          width: 200,
          alignment: Alignment.center,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
