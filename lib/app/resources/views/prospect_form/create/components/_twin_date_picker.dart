part of 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';

class _TwinDatePicker extends StatelessWidget {
  ProspectFormCreateStateController state = Get.find<ProspectFormCreateStateController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            return GestureDetector(
              onTap: () {
                RegularDatePicker(
                  onSelected: state.listener.onDateStartSelected,
                  displaydate: state.formSource.prosstartdate,
                  initialdate: state.formSource.prosstartdate,
                ).show();
              },
              child: IconInput(
                icon: "assets/svg/calendar.svg",
                label: "Start Date",
                enabled: false,
                hintText: "Choose Date",
                value: state.formSource.prosstartdateString,
                validator: state.formSource.validator.prosstartdate,
              ),
            );
          }),
        ),
        SizedBox(width: RegularSize.s),
        Expanded(
          child: Obx(() {
            return GestureDetector(
              onTap: () {
                RegularDatePicker(
                  onSelected: state.listener.onDateEndSelected,
                  initialdate: state.formSource.prosenddate,
                  displaydate: state.formSource.prosenddate,
                  minDate: state.formSource.prosstartdate,
                ).show();
              },
              child: IconInput(
                icon: "assets/svg/calendar.svg",
                label: "End Date",
                hintText: "Choose Date",
                enabled: false,
                value: state.formSource.prosenddateString,
                validator: state.formSource.validator.prosenddate,
              ),
            );
          }),
        ),
      ],
    );
  }
}
