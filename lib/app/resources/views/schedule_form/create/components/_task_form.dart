// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _TaskForm extends StatelessWidget {
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
            controller: $.formSource.schestartdateTEC,
            initialDate: $.formSource.schestartdate,
            onSelected: $.listener.onDateStartSelected,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _StarttimeDropdown(
          onTimeStartSelected: $.listener.onTimeStartSelected,
          timeStartController: $.formSource.schestarttimeDC,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _AlldayCheckbox(
          onChecked: $.listener.onAlldayValueChanged,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _DescriptionInput(controller: $.formSource.schedescTEC),
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
