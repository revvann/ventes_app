part of 'package:ventes/views/schedule_form/create/schedule_fc.dart';

class _RemindInput extends StatelessWidget {
  _RemindInput({
    required this.controller,
  });
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return IconInput(
      icon: "assets/svg/alarm.svg",
      label: "Remind (In Minute)",
      hintText: "try 5",
      controller: controller,
      inputType: TextInputType.number,
    );
  }
}
