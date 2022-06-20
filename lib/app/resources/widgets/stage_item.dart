import 'package:flutter/material.dart';
import 'package:ventes/constants/regular_color.dart';

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
