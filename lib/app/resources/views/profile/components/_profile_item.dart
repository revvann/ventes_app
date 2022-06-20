part of 'package:ventes/app/resources/views/profile/profile.dart';

class _ProfileItem extends StatelessWidget {
  String title;
  String value;
  Color color;

  _ProfileItem({
    required this.title,
    required this.value,
    this.color = RegularColor.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }
}
