part of 'package:ventes/views/schedule_form/create/schedule_fc.dart';

class _AlldayCheckbox extends StatelessWidget {
  _AlldayCheckbox({
    required this.onChecked,
  });
  void Function(bool value) onChecked;

  @override
  Widget build(BuildContext context) {
    return RegularCheckbox(
      label: "All Day",
      onChecked: onChecked,
    );
  }
}
