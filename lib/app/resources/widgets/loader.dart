// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:ventes/app/resources/widgets/regular_dialog.dart';
import 'package:ventes/constants/regular_color.dart';

class Loader {
  Future show() {
    return RegularDialog(
      width: 80,
      height: 100,
      dismissable: false,
      child: Container(
        alignment: Alignment.center,
        child: LoaderAnimation(),
      ),
    ).show();
  }
}

class LoaderAnimation extends StatefulWidget {
  const LoaderAnimation({Key? key}) : super(key: key);

  @override
  State<LoaderAnimation> createState() => _LoaderAnimationState();
}

class _LoaderAnimationState extends State<LoaderAnimation> with AnimationMixin {
  late Animation<double> bubble1;
  late AnimationController bubble1Controller;
  late Animation<double> bubble2;
  late AnimationController bubble2Controller;
  late Animation<double> bubble3;
  late AnimationController bubble3Controller;

  @override
  initState() {
    super.initState();
    bubble1Controller = createController();
    bubble1Controller.duration = Duration(milliseconds: 700);
    Tween<double> bubble1Tween = Tween<double>(begin: 0.3, end: 1.0);
    bubble1 = bubble1Tween.animate(CurvedAnimation(parent: bubble1Controller, curve: Curves.ease));

    bubble2Controller = createController();
    bubble2Controller.duration = Duration(milliseconds: 700);
    Tween<double> bubble2Tween = Tween<double>(begin: 0.3, end: 1.0);
    bubble2 = bubble2Tween.animate(CurvedAnimation(parent: bubble2Controller, curve: Curves.ease));

    bubble3Controller = createController();
    bubble3Controller.duration = Duration(milliseconds: 700);
    Tween<double> bubble3Tween = Tween<double>(begin: 0.3, end: 1.0);
    bubble3 = bubble3Tween.animate(CurvedAnimation(parent: bubble3Controller, curve: Curves.ease));

    bubble1Controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        bubble1Controller.reverse();
        bubble2Controller.forward();
      }
    });
    bubble2Controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        bubble2Controller.reverse();
        bubble3Controller.forward();
      }
    });
    bubble3Controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        bubble3Controller.reverse();
        bubble1Controller.forward();
      }
    });
    bubble1Controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            AnimatedBuilder(
              animation: bubble1Controller,
              builder: (_, value) => Expanded(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RegularColor.primary.withOpacity(bubble1.value),
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: bubble2Controller,
              builder: (_, value) => Expanded(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RegularColor.primary.withOpacity(bubble2.value),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: bubble3Controller,
              builder: (_, value) => Expanded(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RegularColor.primary.withOpacity(bubble3.value),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
