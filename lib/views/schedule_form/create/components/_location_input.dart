part of 'package:ventes/views/schedule_form/create/schedule_fc.dart';

class _LocationInput extends StatelessWidget {
  _LocationInput({
    required this.controller,
  });
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return IconInput(
      icon: "assets/svg/marker.svg",
      label: "Location",
      hintText: "Choose location",
      controller: controller,
      enabled: false,
    );
  }
}
