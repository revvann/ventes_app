part of 'package:ventes/app/resources/views/prospect_assign/prospect_assign.dart';

class _ProspectAssignList extends StatelessWidget {
  ProspectAssignStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: state.dataSource.prospectAssigns.length,
        itemBuilder: (_, index) {
          ProspectAssign prospectAssign = state.dataSource.prospectAssigns[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: RegularSize.m,
                horizontal: RegularSize.m,
              ),
              margin: EdgeInsets.only(
                bottom: RegularSize.m,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(RegularSize.m),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _UserItem(prospectAssign.prospectassign!),
                      ),
                      SizedBox(width: RegularSize.s),
                      PopupMenu(
                        controller: state.property.createPopupController(index),
                        dropdownSettings: DropdownSettings(
                          width: 100,
                          offset: Offset(10, 5),
                          builder: (controller) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: RegularSize.s,
                              horizontal: RegularSize.s,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MenuItem(
                                  title: "Detail",
                                  icon: "assets/svg/detail.svg",
                                  onTap: () => showProspectActivity(prospectAssign),
                                )
                              ],
                            ),
                          ),
                        ),
                        child: Container(
                          width: 20,
                          height: 20,
                          padding: EdgeInsets.all(RegularSize.xs),
                          alignment: Alignment.center,
                          child: Transform.rotate(
                            angle: pi / 2,
                            child: SvgPicture.asset(
                              "assets/svg/menu-dots.svg",
                              color: RegularColor.dark,
                              width: RegularSize.m,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void showProspectActivity(ProspectAssign prospectAssign) {
    RegularDialog(
      width: Get.width * 0.9,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        vertical: RegularSize.m,
        horizontal: RegularSize.m,
      ),
      child: _ProspectAssignDetail(prospectAssign),
    ).show();
  }
}

class _UserItem extends StatelessWidget {
  _UserItem(
    this.userdt,
  );
  UserDetail? userdt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Text(
            getInitials(userdt?.user?.userfullname ?? ""),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          decoration: BoxDecoration(
            color: RegularColor.primary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: RegularSize.s),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userdt?.user?.userfullname ?? "",
              style: TextStyle(
                color: RegularColor.dark,
                fontSize: 16,
              ),
            ),
            Text(
              userdt?.usertype?.typename ?? "-",
              style: TextStyle(
                color: RegularColor.gray,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
