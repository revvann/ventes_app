// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect/prospect.dart';

class _ProspectList extends StatelessWidget {
  ProspectStateController state = Get.find<ProspectStateController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: RegularSize.m),
      child: Obx(
        () {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.dataSource.prospects.length,
            itemBuilder: (_, index) {
              Prospect prospect = state.dataSource.prospects[index];
              return ProspectCard(
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
              );
            },
          );
        },
      ),
    );
  }
}
