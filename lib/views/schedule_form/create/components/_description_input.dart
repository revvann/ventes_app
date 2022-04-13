part of 'package:ventes/views/schedule_form/create/schedule_fc.dart';

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
