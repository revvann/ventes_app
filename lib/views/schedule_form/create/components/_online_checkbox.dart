part of 'package:ventes/views/schedule_form/create/schedule_fc.dart';

class _OnlineCheckbox extends StatelessWidget {
  _OnlineCheckbox({
    required this.onChecked,
  });

  void Function(bool value) onChecked;

  @override
  Widget build(BuildContext context) {
    return RegularCheckbox(
      label: "Online",
      onChecked: onChecked,
    );
  }
}
