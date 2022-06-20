// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/settings_state_controller.dart';
import 'package:ventes/constants/regular_color.dart';

class SettingsView extends GetView<SettingsStateController> {
  static const String route = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Row(
                    children: [
                      StageItem(
                        height: 40,
                        width: 80,
                        child: Text(
                          "Open",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      StageItem(
                        height: 40,
                        width: 90,
                        child: Text(
                          "Pending",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      StageItem(
                        height: 40,
                        width: 90,
                        color: RegularColor.green,
                        child: Text(
                          "Process",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      StageItem(
                        height: 40,
                        width: 80,
                        child: Text(
                          "Done",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StageItem extends StatelessWidget {
  double? width;
  double height;
  Widget child;
  Color? color;

  StageItem({
    required this.height,
    this.width,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StagePainter(
        angleWidth: height / 2,
        color: color ?? RegularColor.gray,
      ),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: SizedBox(
          width: width != null ? width! - height : null,
          child: child,
        ),
      ),
    );
  }
}

class StagePainter extends CustomPainter {
  double angleWidth;
  Color color;

  StagePainter({
    required this.angleWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(angleWidth, size.height / 2);
    path.lineTo(0, size.height);
    path.lineTo(size.width - angleWidth, size.height);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - angleWidth, 0);
    path.moveTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
