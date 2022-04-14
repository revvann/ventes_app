part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _AddmemberCheckbox extends StatelessWidget {
  _AddmemberCheckbox({
    required this.onChecked,
    required this.value,
    required this.enabled,
  });
  void Function(bool value) onChecked;
  bool enabled;
  bool value;

  @override
  Widget build(BuildContext context) {
    return RegularCheckbox(
      label: "Add Member",
      onChecked: onChecked,
      enabled: enabled,
      value: value,
    );
  }
}
