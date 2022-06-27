// ignore_for_file: prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/prospect_dashboard/prospect_dashboard.dart';

class _MiniStatCard extends StatelessWidget {
  _MiniStatCard({
    Key? key,
    this.margin,
    this.width = double.infinity,
    this.height = double.infinity,
    required this.text,
    required this.value,
    this.color = RegularColor.primary,
  }) : super(key: key);
  EdgeInsets? margin;
  double width, height;
  String text, value;
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: RegularColor.dark,
            ),
          ),
          Container(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
              ),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: RegularSize.s,
              vertical: RegularSize.xs,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(RegularSize.s),
            ),
          ),
        ],
      ),
    );
  }
}
