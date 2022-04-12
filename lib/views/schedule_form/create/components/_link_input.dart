part of 'package:ventes/views/schedule_form/create/schedule_fc.dart';

class _LinkInput extends StatelessWidget {
  _LinkInput({
    required this.controller,
    required this.enabled,
  });

  TextEditingController controller;
  bool enabled;

  @override
  Widget build(BuildContext context) {
    return IconInput(
      icon: "assets/svg/share.svg",
      label: "Meeting Link",
      hintText: "Enter meeting link",
      controller: controller,
      enabled: enabled,
    );
  }
}
