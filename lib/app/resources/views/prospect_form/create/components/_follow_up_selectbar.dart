part of 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';

class _FollowUpSelectbar extends StatelessWidget {
  ProspectFormCreateStateController state = Get.find<ProspectFormCreateStateController>();

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
