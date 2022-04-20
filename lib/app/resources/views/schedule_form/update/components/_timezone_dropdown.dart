part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _TimezoneDropdown extends StatelessWidget {
  _TimezoneDropdown({
    required this.controller,
    this.onSelected,
  });
  DropdownController<String?> controller;
  void Function(String?)? onSelected;

  @override
  Widget build(BuildContext context) {
    return RegularDropdown<String?>(
      label: ScheduleString.schetzLabel,
      controller: controller,
      icon: "assets/svg/timezone.svg",
      onSelected: onSelected,
    );
  }
}
