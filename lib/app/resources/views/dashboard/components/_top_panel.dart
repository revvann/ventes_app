// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/dashboard/dashboard.dart';

class _TopPanel extends StatelessWidget {
  const _TopPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 75,
      left: RegularSize.m,
      right: RegularSize.m,
      child: Container(
        height: 150,
        padding: EdgeInsets.all(
          RegularSize.m,
        ),
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
          children: [
            Text(
              "Norman Osborn",
              style: TextStyle(
                fontSize: 16,
                color: RegularColor.dark,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: RegularSize.xs,
            ),
            Text(
              "New York City, United States",
              style: TextStyle(
                color: RegularColor.dark,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: RegularSize.m,
            ),
            Row(
              children: [
                _TopPanelItem('assets/svg/marker.svg', "15", "Nearby"),
                _TopPanelItem('assets/svg/calendar.svg', "8", "Scheduled"),
                _TopPanelItem('assets/svg/time-check.svg', "3", "Done"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopPanelItem extends StatelessWidget {
  String icon, title, subtitle;
  _TopPanelItem(this.icon, this.title, this.subtitle);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  width: RegularSize.l,
                  color: RegularColor.green,
                ),
                SizedBox(
                  width: RegularSize.s,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: RegularColor.dark,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: RegularSize.xs,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RegularColor.gray,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
