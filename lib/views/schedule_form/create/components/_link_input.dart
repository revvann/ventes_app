part of 'package:ventes/views/schedule_form/create/schedule_fc.dart';

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
