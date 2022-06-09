// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

part of 'package:ventes/app/resources/views/dashboard/dashboard.dart';

class _AppBar extends StatelessWidget {
  DashboardStateController get state => Get.find<DashboardStateController>();

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
            PopupMenu(
              controller: Get.put(PopupMenuController(), tag: "SchedulePopup"),
              dropdownSettings: DropdownSettings(
                width: 200,
                offset: Offset(10, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: RegularSize.s,
                    horizontal: RegularSize.s,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() {
                        return _UserMenuItem(
                          user: state.dataSource.account!,
                          isActive: true,
                        );
                      }),
                      MenuDivider(text: "Account"),
                      Obx(() {
                        return Container(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: state.dataSource.accounts.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              UserDetail user = state.dataSource.accounts[index];
                              return _UserMenuItem(user: user, onTap: () => state.listener.switchAccount(user.userdtid!));
                            },
                          ),
                        );
                      }),
                      MenuDivider(),
                      MenuItem(
                        title: "Sign Out",
                        icon: "assets/svg/signout.svg",
                        onTap: state.properties.logout,
                        color: RegularColor.red,
                      ),
                    ],
                  ),
                ),
              ),
              child: Container(
                child: Container(
                  width: RegularSize.xxl,
                  height: RegularSize.xxl,
                  alignment: Alignment.center,
                  child: Obx(() {
                    return Text(
                      state.properties.shortName ?? "AA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RegularColor.primary,
                  ),
                ),
              ),
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
