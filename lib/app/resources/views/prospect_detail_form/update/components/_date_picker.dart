part of 'package:ventes/app/resources/views/prospect_detail_form/update/prospect_detail_fu.dart';

class _DatePicker extends StatelessWidget {
  ProspectDetailFormUpdateStateController state = Get.find<ProspectDetailFormUpdateStateController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RegularDatePicker(
          onSelected: state.listener.onDateSelected,
          displaydate: state.formSource.date,
          initialdate: state.formSource.date,
        ).show();
      },
      child: Obx(() {
        return IconInput(
          icon: "assets/svg/calendar.svg",
          label: "Date",
          enabled: false,
          hintText: "Choose Date",
          value: state.formSource.dateString,
          validator: state.formSource.validator.prosdtdate,
        );
      }),
    );
  }
}
