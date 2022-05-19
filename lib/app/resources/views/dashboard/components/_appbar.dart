// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/dashboard/dashboard.dart';

class _AppBar extends StatelessWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: RegularSize.s,
          vertical: RegularSize.m,
        ),
        alignment: Alignment.topCenter,
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 75,
                ),
              ],
            ),
            PopupMenuButton<String>(
              elevation: 0.3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(RegularSize.m),
              ),
              padding: EdgeInsets.zero,
              child: Container(
                width: RegularSize.xxl,
                height: RegularSize.xxl,
                alignment: Alignment.center,
                child: Text(
                  "SS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: RegularColor.primary,
                ),
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "edit",
                  child: Row(
                    children: [
                      Container(
                        width: RegularSize.xl,
                        height: RegularSize.xl,
                        alignment: Alignment.center,
                        child: Text(
                          "SS",
                          style: TextStyle(
                            color: RegularColor.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: RegularColor.secondary,
                        ),
                      ),
                      SizedBox(
                        width: RegularSize.s,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Stephen Strange",
                            style: TextStyle(
                              fontSize: 14,
                              color: RegularColor.dark,
                            ),
                          ),
                          Text(
                            "Sales",
                            style: TextStyle(
                              fontSize: 12,
                              color: RegularColor.gray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: "delete",
                  child: Row(
                    children: [
                      Container(
                        width: RegularSize.xl,
                        height: RegularSize.xl,
                        alignment: Alignment.center,
                        child: Text(
                          "SS",
                          style: TextStyle(
                            color: RegularColor.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: RegularColor.secondary,
                        ),
                      ),
                      SizedBox(
                        width: RegularSize.s,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Stephen Strange",
                            style: TextStyle(
                              fontSize: 14,
                              color: RegularColor.dark,
                            ),
                          ),
                          Text(
                            "Director",
                            style: TextStyle(
                              fontSize: 12,
                              color: RegularColor.gray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }
}
