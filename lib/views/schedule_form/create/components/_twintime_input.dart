// ignore_for_file: prefer_const_constructors

part of 'package:ventes/views/schedule_form/create/schedule_fc.dart';

class _TwintimeInput extends StatelessWidget {
  _TwintimeInput({
    required this.timeStartController,
    required this.timeEndController,
    required this.onTimeStartSelected,
    required this.onTimeEndSelected,
  });

  DropdownController<String?>? timeStartController;
  DropdownController<String?>? timeEndController;
  void Function(String? value) onTimeStartSelected;
  void Function(String? value) onTimeEndSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RegularDropdown<String?>(
            label: "Start Time",
            controller: timeStartController,
            icon: "assets/svg/history.svg",
            onSelected: onTimeStartSelected,
          ),
        ),
        SizedBox(
          width: RegularSize.s,
        ),
        Expanded(
          child: RegularDropdown<String?>(
            label: "End Time",
            icon: "assets/svg/history.svg",
            controller: timeEndController,
            onSelected: onTimeEndSelected,
          ),
        ),
      ],
    );
  }
}
