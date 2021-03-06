part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _RemindInput extends StatelessWidget {
  _RemindInput({
    required this.controller,
  });
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return IconInput(
      icon: "assets/svg/alarm.svg",
      label: ScheduleString.scheremindLabel,
      hintText: "try 5",
      controller: controller,
      inputType: TextInputType.number,
    );
  }
}
