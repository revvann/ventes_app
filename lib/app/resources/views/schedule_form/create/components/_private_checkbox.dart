part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _PrivateCheckbox extends StatelessWidget {
  _PrivateCheckbox({
    required this.onChecked,
  });
  void Function(bool value) onChecked;

  @override
  Widget build(BuildContext context) {
    return RegularCheckbox(
      label: ScheduleString.scheprivateLabel,
      onChecked: onChecked,
    );
  }
}
