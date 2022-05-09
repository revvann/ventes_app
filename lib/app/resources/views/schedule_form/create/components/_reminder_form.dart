// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _ReminderForm extends StatelessWidget {
  ScheduleFormCreateStateController $ = Get.find<ScheduleFormCreateStateController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _DatestartInput(
            controller: $.schestartdateTEC,
            initialDate: $.schestartdate,
            onSelected: $.onDateStartSelected,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _StarttimeDropdown(
          onTimeStartSelected: $.onTimeStartSelected,
          timeStartController: $.schestarttimeDC,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _AlldayCheckbox(
          onChecked: $.onAlldayValueChanged,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
      ],
    );
  }
}
