// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect_detail/prospect_detail.dart';

class _DetailList extends StatelessWidget {
  ProspectDetailStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return HandlerContainer<Function(List<ProspectDetail>)>(
      handlers: [state.dataSource.prospectDetailsHandler],
      width: RegularSize.xl,
      builder: (prospectDetails) => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: prospectDetails.length,
        itemBuilder: (_, index) {
          ProspectDetail _prospectDetail = prospectDetails[index];
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
                      formatDate(dbParseDate(_prospectDetail.prospectdtdate!)),
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
                        _prospectDetail.prospectdtcat?.typename ?? "",
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
                                onTap: () => state.listener.onProspectDetailClicked(_prospectDetail.prospectdtid!),
                              ),
                              MenuItem(
                                title: "Delete",
                                icon: "assets/svg/delete.svg",
                                onTap: () => state.listener.deleteDetail(_prospectDetail.prospectdtid!),
                              ),
                              MenuItem(
                                title: "Detail",
                                icon: "assets/svg/detail.svg",
                                onTap: () => showProspectDetail(_prospectDetail),
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
                  _prospectDetail.prospectdttype?.typename ?? "",
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

  void showProspectDetail(ProspectDetail detail) {
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
