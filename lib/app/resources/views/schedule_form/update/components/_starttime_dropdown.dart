// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _StarttimeDropdown extends StatelessWidget {
  _StarttimeDropdown({
    required this.timeStartController,
    required this.onTimeStartSelected,
  });

  DropdownController<String?>? timeStartController;
  void Function(String? value) onTimeStartSelected;

  @override
  Widget build(BuildContext context) {
    return RegularDropdown<String?>(
      label: ScheduleString.schestarttimeLabel,
      controller: timeStartController,
      icon: "assets/svg/history.svg",
      onSelected: onTimeStartSelected,
    );
  }
}
