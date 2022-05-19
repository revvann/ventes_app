// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/dashboard/dashboard.dart';

class _MenuItem extends StatelessWidget {
  Function() onTap;
  Color color;
  String icon;
  String text;

  _MenuItem({required this.onTap, required this.color, required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(RegularSize.m),
            border: Border.all(
              color: RegularColor.disable,
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 30,
                color: Color(0xFF0157E4).withOpacity(0.1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: RegularSize.xxl,
                height: RegularSize.xxl,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  icon,
                  width: RegularSize.l,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: RegularSize.s,
              ),
              Text(
                text,
                style: TextStyle(
                  color: RegularColor.dark,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
