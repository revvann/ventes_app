// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/prospect/prospect.dart';

class _FollowUpSelectBar extends StatelessWidget {
  ProspectStateController state = Get.find<ProspectStateController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: RegularSize.m),
      child: Obx(() {
        return KeyableSelectBar<int>(
          height: RegularSize.xl,
          label: "Follow Up Type",
          items: state.dataSource.followUpItems,
          onSelected: state.listener.onFollowUpSelected,
          activeIndex: state.formSource.prostype,
        );
      }),
    );
  }
}
