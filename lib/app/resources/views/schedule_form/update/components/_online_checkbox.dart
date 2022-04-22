part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _OnlineCheckbox extends StatelessWidget {
  _OnlineCheckbox({
    required this.onChecked,
    required this.value,
  });

  bool value;
  void Function(bool value) onChecked;

  @override
  Widget build(BuildContext context) {
    return RegularCheckbox(
      label: ScheduleString.scheonlineLabel,
      value: value,
      onChecked: onChecked,
    );
  }
}
