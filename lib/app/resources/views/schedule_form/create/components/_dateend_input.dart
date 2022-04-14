part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _DateendInput extends StatelessWidget {
  _DateendInput({
    required this.onSelected,
    required this.initialDate,
    required this.controller,
    this.minDate,
  });

  DateTime initialDate;
  TextEditingController controller;
  void Function(DateTime? value) onSelected;
  DateTime? minDate;

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
        label: ScheduleString.scheenddateLabel,
        enabled: false,
        controller: controller,
      ),
    );
  }
}
