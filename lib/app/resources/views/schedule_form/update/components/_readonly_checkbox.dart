part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _ReadOnlyCheckbox extends StatelessWidget {
  _ReadOnlyCheckbox({
    required this.onChecked,
    required this.value,
  });

  void Function(bool value) onChecked;
  bool value;

  @override
  Widget build(BuildContext context) {
    return RegularCheckbox(
      label: "Read Only",
      onChecked: onChecked,
      value: value,
    );
  }
}
