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
            controller: $.formSource.schestartdateTEC,
            initialDate: $.formSource.schestartdate,
            onSelected: $.formSource.listener.onDateStartSelected,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _StarttimeDropdown(
          onTimeStartSelected: $.formSource.listener.onTimeStartSelected,
          timeStartController: $.formSource.schestarttimeDC,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _AlldayCheckbox(
            onChecked: $.formSource.listener.onAlldayValueChanged,
            value: $.formSource.scheallday,
          );
        }),
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