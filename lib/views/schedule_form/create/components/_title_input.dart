part of "package:ventes/views/schedule_form/create/schedule_fc.dart";

class _TitleInput extends StatelessWidget {
  _TitleInput({
    required this.controller,
    this.validator,
  });
  final TextEditingController controller;
  String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return RegularInput(
      controller: controller,
      label: ScheduleString.schenmLabel,
      hintText: "Enter title",
      validator: validator,
    );
  }
}
