// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/dashboard/dashboard.dart';

class _TopPanel extends StatelessWidget {
  Controller state = Get.find<Controller>();

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
        child: Obx(() {
          bool currentPositionProcess = state.dataSource.currentPositionHandler.onProcess;
          bool userProcess = state.dataSource.userHandler.onProcess;
          bool scheduleCountHandler = state.dataSource.scheduleCountHandler.onProcess;
          bool customerHandler = state.dataSource.customerHandler.onProcess;
          return LoadingContainer(
            isLoading: currentPositionProcess && userProcess && scheduleCountHandler && customerHandler,
            width: 40,
            child: Column(
              children: [
                Obx(() {
                  return Text(
                    state.dataSource.account?.user?.userfullname ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      color: RegularColor.dark,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
                SizedBox(
                  height: RegularSize.xs,
                ),
                Obx(() {
                  return Text(
                    state.dataSource.currentPosition?.adresses?.first.formattedAddress ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: RegularColor.dark,
                      fontSize: 14,
                    ),
                  );
                }),
                SizedBox(
                  height: RegularSize.m,
                ),
                Row(
                  children: [
                    Obx(() {
                      return _TopPanelItem('assets/svg/user.svg', state.dataSource.customers.length.toString(), "Customer");
                    }),
                    Obx(() {
                      return _TopPanelItem('assets/svg/calendar.svg', state.dataSource.scheduleCount.toString(), "Scheduled");
                    }),
                    _TopPanelItem('assets/svg/time-check.svg', "3", "Done"),
                  ],
                ),
              ],
            ),
          );
        }),
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
