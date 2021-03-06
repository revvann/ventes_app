// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect/prospect.dart';

class _ProspectList extends StatelessWidget {
  ProspectStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: RegularSize.m),
      child: HandlerContainer<Function(List<Prospect>)>(
        handlers: [
          state.dataSource.prospectsHandler,
        ],
        width: RegularSize.xl,
        builder: (prospects) => ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: prospects.length,
          itemBuilder: (_, index) {
            Prospect prospect = prospects[index];
            return GestureDetector(
              onTap: () {
                state.property.selectedProspect = prospect;
                state.listener.onProspectClicked();
              },
              child: ProspectCard(
                height: 120,
                margin: EdgeInsets.only(
                  bottom: RegularSize.s,
                  top: RegularSize.s,
                ),
                name: prospect.prospectname ?? "",
                customer: prospect.prospectcust?.sbccstmname ?? "",
                owner: prospect.prospectowneruser?.user?.userfullname ?? "",
                status: prospect.prospectstatus?.typename ?? "",
                date: prospect.prospectstartdate ?? "",
                popupController: state.property.createPopupController(index),
                popupItems: [
                  MenuItem(
                    title: "Edit",
                    icon: "assets/svg/edit.svg",
                    onTap: () => state.listener.navigateToProspectUpdateForm(prospect.prospectid!),
                  ),
                  MenuItem(
                    title: "Closed Win",
                    color: RegularColor.green,
                    onTap: () => state.listener.onCloseWonClicked(prospect.prospectid!),
                  ),
                  MenuItem(
                    title: "Closed Lost",
                    color: RegularColor.red,
                    onTap: () => onCloseLoseClicked(prospect.prospectid!),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void onCloseLoseClicked(id) async {
    if (state.dataSource.closeLoseStatus != null) {
      Map<String, dynamic>? data = await _LostReasonForm().show();
      if (data != null) {
        data["prospectstatusid"] = state.dataSource.closeLoseStatus?.typeid;
        state.dataSource.prospectUpdateHandler.fetcher.run(id, data);
      }
    }
  }
}
