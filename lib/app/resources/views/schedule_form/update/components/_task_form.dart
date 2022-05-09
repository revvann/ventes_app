// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _TaskForm extends StatelessWidget {
  ScheduleFormUpdateStateController $ = Get.find<ScheduleFormUpdateStateController>();

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
        Obx(() {
          return _AlldayCheckbox(
            onChecked: $.onAlldayValueChanged,
            value: $.scheallday,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _DescriptionInput(controller: $.schedescTEC),
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
