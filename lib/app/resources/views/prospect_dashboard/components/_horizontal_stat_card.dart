// ignore_for_file: prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/prospect_dashboard/prospect_dashboard.dart';

class _HorizontalStatCard extends StatelessWidget {
  _HorizontalStatCard({
    Key? key,
    this.margin,
    this.width = double.infinity,
    this.height = double.infinity,
    required this.text,
    required this.value,
    required this.icon,
    this.color = RegularColor.primary,
  }) : super(key: key);
  EdgeInsets? margin;
  double width, height;
  String text, value, icon;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: margin,
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.s,
        vertical: RegularSize.s,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RegularSize.s),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 30,
            color: Color(0xFF0157E4).withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              icon,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(RegularSize.s),
            ),
          ),
          SizedBox(width: RegularSize.s),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: RegularColor.dark,
                  ),
                ),
                Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: RegularColor.gray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
