part of 'package:ventes/views/schedule_form/create/schedule_fc.dart';

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
