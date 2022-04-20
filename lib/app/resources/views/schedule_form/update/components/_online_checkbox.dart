part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _OnlineCheckbox extends StatelessWidget {
  _OnlineCheckbox({
    required this.onChecked,
  });

  void Function(bool value) onChecked;

  @override
  Widget build(BuildContext context) {
    return RegularCheckbox(
      label: ScheduleString.scheonlineLabel,
      onChecked: onChecked,
    );
  }
}
