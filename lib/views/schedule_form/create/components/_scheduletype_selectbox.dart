part of 'package:ventes/views/schedule_form/create/schedule_fc.dart';

class _ScheduletypeSelectbox extends StatelessWidget {
  _ScheduletypeSelectbox({
    required this.onSelected,
    required this.activeIndex,
  });

  void Function(int value) onSelected;
  int activeIndex;

  @override
  Widget build(BuildContext context) {
    return RegularSelectBox<String>(
      label: ScheduleString.schetypeLabel,
      onSelected: onSelected,
      activeIndex: activeIndex,
      items: [
        "Event",
        "Task",
        "Reminder",
      ],
    );
  }
}
