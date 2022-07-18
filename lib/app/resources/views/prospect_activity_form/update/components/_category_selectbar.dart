// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect_activity_form/update/prospect_activity_fu.dart';

class _CategorySelectbar extends StatelessWidget {
  Controller state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return KeyableSelectBar<int>(
        nullable: false,
        height: RegularSize.xl,
        label: "Category",
        items: state.dataSource.categoryItems,
        onSelected: state.listener.onFollowUpSelected,
        activeIndex: state.formSource.prosdtcatid ?? 0,
      );
    });
  }
}
