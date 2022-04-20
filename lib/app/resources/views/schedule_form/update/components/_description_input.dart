part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _DescriptionInput extends StatelessWidget {
  _DescriptionInput({
    required this.controller,
  });

  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return EditorInput(
      label: ScheduleString.schedescLabel,
      hintText: "Write about this event",
      controller: controller,
    );
  }
}
