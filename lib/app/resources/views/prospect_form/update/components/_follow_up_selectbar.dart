part of 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';

class _FollowUpSelectbar extends StatelessWidget {
  ProspectFormUpdateStateController state = Get.find<ProspectFormUpdateStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return KeyableSelectBar<int>(
        nullable: false,
        height: RegularSize.xl,
        label: "Follow Up Type",
        items: state.dataSource.followUpItems,
        onSelected: state.listener.onFollowUpSelected,
        activeIndex: state.formSource.prostype ?? 0,
      );
    });
  }
}
