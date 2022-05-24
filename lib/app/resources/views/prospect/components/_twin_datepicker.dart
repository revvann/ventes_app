// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect/prospect.dart';

class _TwinDatePicker extends StatelessWidget {
  ProspectStateController state = Get.find<ProspectStateController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: RegularSize.m),
      child: Row(
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
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
