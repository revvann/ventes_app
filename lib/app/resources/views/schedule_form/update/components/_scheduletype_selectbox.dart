part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _ScheduletypeSelectbox extends StatelessWidget {
  _ScheduletypeSelectbox({
    required this.onSelected,
    required this.activeIndex,
    required this.items,
  });

  void Function(int value) onSelected;
  List<String> items;
  int activeIndex;

  @override
  Widget build(BuildContext context) {
    return RegularSelectBox<String>(
      label: ScheduleString.schetypeLabel,
      onSelected: onSelected,
      activeIndex: activeIndex,
      items: items,
    );
  }
}
