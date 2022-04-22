part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _AlldayCheckbox extends StatelessWidget {
  _AlldayCheckbox({
    required this.onChecked,
    required this.value,
  });
  bool value;
  void Function(bool value) onChecked;

  @override
  Widget build(BuildContext context) {
    return RegularCheckbox(
      value: value,
      label: ScheduleString.schealldayLabel,
      onChecked: onChecked,
    );
  }
}
