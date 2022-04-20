part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _LinkInput extends StatelessWidget {
  _LinkInput({
    required this.controller,
    required this.enabled,
    this.validator,
  });

  TextEditingController controller;
  bool enabled;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return IconInput(
      icon: "assets/svg/share.svg",
      label: ScheduleString.scheonlinkLabel,
      hintText: "Enter meeting link",
      controller: controller,
      enabled: enabled,
      validator: validator,
    );
  }
}
