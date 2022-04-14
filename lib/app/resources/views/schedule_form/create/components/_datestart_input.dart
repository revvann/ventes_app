part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _DatestartInput extends StatelessWidget {
  _DatestartInput({
    required this.onSelected,
    required this.initialDate,
    required this.controller,
    this.minDate,
    this.validator,
  });

  void Function(DateTime? value) onSelected;
  DateTime initialDate;
  TextEditingController controller;
  DateTime? minDate;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RegularDatePicker(
          onSelected: onSelected,
          initialdate: initialDate,
          minDate: minDate,
        ).show();
      },
      child: IconInput(
        icon: "assets/svg/calendar.svg",
        label: ScheduleString.schestartdateLabel,
        enabled: false,
        controller: controller,
        validator: validator,
      ),
    );
  }
}
