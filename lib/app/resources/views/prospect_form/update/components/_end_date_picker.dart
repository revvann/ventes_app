part of 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';

class _EndDatePicker extends StatelessWidget {
  ProspectFormUpdateStateController state = Get.find<ProspectFormUpdateStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return GestureDetector(
          onTap: () {
            RegularDatePicker(
              onSelected: state.listener.onExpDateEndSelected,
              initialdate: state.formSource.prosexpenddate,
              displaydate: state.formSource.prosexpenddate,
            ).show();
          },
          child: IconInput(
            icon: "assets/svg/calendar.svg",
            label: "Expectation End Date",
            hintText: "Choose Date",
            enabled: false,
            value: state.formSource.prosexpenddateString,
            validator: state.formSource.validator.prosexpenddate,
          ),
        );
      },
    );
  }
}
