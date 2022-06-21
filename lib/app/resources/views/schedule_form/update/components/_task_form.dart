// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _TaskForm extends StatelessWidget {
  ScheduleFormUpdateStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _DatestartInput(
            controller: state.formSource.schestartdateTEC,
            initialDate: state.formSource.schestartdate,
            onSelected: state.listener.onDateStartSelected,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _StarttimeDropdown(
          onTimeStartSelected: state.listener.onTimeStartSelected,
          timeStartController: state.formSource.schestarttimeDC,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _AlldayCheckbox(
            onChecked: state.listener.onAlldayValueChanged,
            value: state.formSource.scheallday,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _DescriptionInput(controller: state.formSource.schedescTEC),
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
