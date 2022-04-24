// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:ventes/app/resources/widgets/regular_dialog.dart';
import 'package:ventes/constants/regular_color.dart';

class Loader {
  Future show() {
    return RegularDialog(
      width: 120,
      height: 160,
      dismissable: false,
      backgroundColor: Colors.transparent,
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
  late TimelineTween<AnimationType> bubble1;

  @override
  initState() {
    super.initState();
    double bubbleSize = 37.5;

    Tween<Offset> bubbleTween0 = Tween<Offset>(begin: Offset(bubbleSize, 0), end: Offset(bubbleSize, 0));
    Tween<Offset> bubbleTween1 = Tween<Offset>(begin: Offset(bubbleSize, 0), end: Offset(0, bubbleSize));
    Tween<Offset> bubbleTween2 = Tween<Offset>(begin: Offset(0, bubbleSize), end: Offset(-bubbleSize, 0));
    Tween<Offset> bubbleTween3 = Tween<Offset>(begin: Offset(-bubbleSize, 0), end: Offset(0, -bubbleSize));
    Tween<Offset> bubbleTween4 = Tween<Offset>(begin: Offset(0, -bubbleSize), end: Offset(bubbleSize, 0));

    Tween<double> circleTween0 = Tween<double>(begin: pi * 0, end: pi * 0);
    Tween<double> circleTween1 = Tween<double>(begin: pi * 0, end: pi * 0.5);
    Tween<double> circleTween2 = Tween<double>(begin: pi * 0.5, end: pi);
    Tween<double> circleTween3 = Tween<double>(begin: pi, end: pi * 1.5);
    Tween<double> circleTween4 = Tween<double>(begin: pi * 1.5, end: pi * 2);

    Duration animDuration = Duration(milliseconds: 400);
    Duration delay = Duration(milliseconds: 200);

    bubble1 = TimelineTween<AnimationType>()
      ..addScene(begin: Duration.zero, end: delay)
          .animate(AnimationType.translate, tween: bubbleTween0)
          .animate(AnimationType.rotate, tween: circleTween0)
          .addSubsequentScene(duration: animDuration, delay: delay)
          .animate(AnimationType.translate, tween: bubbleTween1)
          .animate(AnimationType.rotate, tween: circleTween1)
          .addSubsequentScene(duration: animDuration, delay: delay)
          .animate(AnimationType.translate, tween: bubbleTween2)
          .animate(AnimationType.rotate, tween: circleTween2)
          .addSubsequentScene(duration: animDuration, delay: delay)
          .animate(AnimationType.translate, tween: bubbleTween3)
          .animate(AnimationType.rotate, tween: circleTween3)
          .addSubsequentScene(duration: animDuration, delay: delay)
          .animate(AnimationType.translate, tween: bubbleTween4)
          .animate(AnimationType.rotate, tween: circleTween4);
  }

  @override
  Widget build(BuildContext context) {
    return LoopAnimation<TimelineValue<AnimationType>>(
      tween: bubble1,
      duration: bubble1.duration,
      builder: (_, __, value) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: value.get(AnimationType.translate),
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: RegularColor.secondary,
                ),
              ),
            ),
            Transform.rotate(
              angle: value.get(AnimationType.rotate),
              child: CustomPaint(
                size: Size(70, 70),
                painter: QuarterBorderPainter(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class QuarterBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 15;
    Rect myRect = Rect.fromLTWH(0, 0, size.width, size.height);

    var paint1 = Paint()
      ..color = RegularColor.primary
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(myRect, pi * 0.25, pi * 1.5, false, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

enum AnimationType {
  translate,
  rotate,
}
