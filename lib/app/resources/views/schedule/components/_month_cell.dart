// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/schedule/schedule.dart';

class _MonthCell extends StatelessWidget {
  _MonthCell({
    this.isSelected = false,
    this.fontSize = 14,
    this.textColor = RegularColor.gray,
    this.appointmentsCount = 0,
    required this.day,
  });
  bool isSelected;
  double fontSize;
  Color textColor;
  int appointmentsCount;
  String day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.xs,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? RegularColor.primary : Colors.white,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
              ),
            ),
            if (appointmentsCount > 0)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  child: Text(
                    "$appointmentsCount",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RegularColor.indigo,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
