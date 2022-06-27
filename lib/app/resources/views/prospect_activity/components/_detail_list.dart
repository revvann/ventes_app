// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect_activity/prospect_activity.dart';

class _DetailList extends StatelessWidget {
  ProspectActivityStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return HandlerContainer<Function(List<ProspectActivity>)>(
      handlers: [state.dataSource.prospectActivitiesHandler],
      width: RegularSize.xl,
      builder: (prospectActivities) => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: prospectActivities.length,
        itemBuilder: (_, index) {
          ProspectActivity _prospectActivity = prospectActivities[index];
          return Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      formatDate(dbParseDate(_prospectActivity.prospectdtdate!)),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: RegularColor.dark,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: RegularSize.s,
                        vertical: RegularSize.xs,
                      ),
                      decoration: BoxDecoration(
                        color: RegularColor.secondary,
                        borderRadius: BorderRadius.circular(RegularSize.s),
                      ),
                      child: Text(
                        _prospectActivity.prospectdtcat?.typename ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    PopupMenu(
                      controller: state.property.createPopupController(index),
                      dropdownSettings: DropdownSettings(
                        width: 150,
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
                                title: "Edit",
                                icon: "assets/svg/edit.svg",
                                onTap: () => state.listener.onProspectActivityClicked(_prospectActivity.prospectdtid!),
                              ),
                              MenuItem(
                                title: "Delete",
                                icon: "assets/svg/delete.svg",
                                onTap: () => state.listener.deleteDetail(_prospectActivity.prospectdtid!),
                              ),
                              MenuItem(
                                title: "Detail",
                                icon: "assets/svg/detail.svg",
                                onTap: () => showProspectActivity(_prospectActivity),
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(
                          left: RegularSize.s,
                        ),
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
                SizedBox(
                  height: RegularSize.m,
                ),
                Text(
                  _prospectActivity.prospectdttype?.typename ?? "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: RegularColor.dark,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showProspectActivity(ProspectActivity detail) {
    RegularDialog(
      width: Get.width * 0.9,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        vertical: RegularSize.m,
        horizontal: RegularSize.m,
      ),
      child: _DetailDialog(detail),
    ).show();
  }
}
