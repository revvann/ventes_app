part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _SharelinkCheckbox extends StatelessWidget {
  _SharelinkCheckbox({
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
      label: "Share Link",
      onChecked: onChecked,
      enabled: enabled,
      value: value,
    );
  }
}
