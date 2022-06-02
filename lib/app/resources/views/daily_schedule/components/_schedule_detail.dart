// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/daily_schedule/daily_schedule.dart';

class _ScheduleDetail extends StatelessWidget {
  const _ScheduleDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My schedule of my life",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: RegularColor.dark,
          ),
        ),
        SizedBox(
          height: RegularSize.xs,
        ),
        Text(
          "Johann A. Schmidt ",
          style: TextStyle(
            fontSize: 14,
            color: RegularColor.gray,
          ),
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _DetailItem(
          title: "Date",
          value: "June 23, 2020 - June 24, 2020",
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        _DetailItem(
          title: "Time",
          value: "10:00 - 18:00",
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        _DetailItem(
          title: "Timezone",
          value: "America/New_York",
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        _DetailItem(
          title: "Remind In",
          value: "5 Minutes",
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        Text(
          "Location",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: RegularColor.dark,
          ),
        ),
        SizedBox(
          height: RegularSize.xs,
        ),
        RichText(
          text: TextSpan(
            text: "http://google.maps.com?q=location&z=15&t=m&hl=en",
            style: TextStyle(
              fontSize: 14,
              color: RegularColor.dark,
            ),
            children: [
              TextSpan(
                text: " Copy",
                style: TextStyle(
                  color: RegularColor.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        Text(
          "Meeting Link",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: RegularColor.dark,
          ),
        ),
        SizedBox(
          height: RegularSize.xs,
        ),
        RichText(
          text: TextSpan(
            text: "https://zoom.us/j/123456789",
            style: TextStyle(
              fontSize: 14,
              color: RegularColor.dark,
            ),
            children: [
              TextSpan(
                text: " Copy",
                style: TextStyle(
                  color: RegularColor.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        _DetailItem(
          title: "Description",
          value:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        Text(
          "Tags",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: RegularColor.dark,
          ),
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        Wrap(
          spacing: RegularSize.s,
          runSpacing: RegularSize.s,
          children: [
            _DetailTag(
              text: "Event",
              color: RegularColor.yellow,
            ),
            _DetailTag(
              text: "Allday",
              color: RegularColor.indigo,
            ),
            _DetailTag(
              text: "Private",
              color: RegularColor.pink,
            ),
            _DetailTag(
              text: "On Site",
              color: RegularColor.green,
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  String title;
  String value;
  Color color;

  _DetailItem({
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
          height: RegularSize.xs,
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

class _DetailTag extends StatelessWidget {
  String text;
  Color color;
  _DetailTag({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.s,
        vertical: RegularSize.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(RegularSize.s),
      ),
    );
  }
}
