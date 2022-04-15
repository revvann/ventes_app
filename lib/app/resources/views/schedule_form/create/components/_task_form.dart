// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _TaskForm extends StatelessWidget {
  _TaskForm(this.controller);
  ScheduleFormCreateStateController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _DatestartInput(
            controller: controller.formSource.schestartdateTEC,
            initialDate: controller.formSource.schestartdate,
            onSelected: controller.formSource.listener.onDateStartSelected,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _StarttimeDropdown(
          onTimeStartSelected: controller.formSource.listener.onTimeStartSelected,
          timeStartController: controller.formSource.schestarttimeDC,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _AlldayCheckbox(
          onChecked: controller.formSource.listener.onAlldayValueChanged,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _DescriptionInput(controller: controller.formSource.schedescTEC),
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
