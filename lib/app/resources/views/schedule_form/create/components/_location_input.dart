part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _LocationInput extends StatelessWidget {
  _LocationInput({
    required this.controller,
    this.validator,
  });
  TextEditingController controller;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return IconInput(
      icon: "assets/svg/marker.svg",
      label: ScheduleString.schelocLabel,
      hintText: "Choose location",
      controller: controller,
      enabled: false,
      validator: validator,
    );
  }
}
