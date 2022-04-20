// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _GuestList extends StatelessWidget {
  _GuestList({
    required this.guests,
    this.onRemove,
    required this.onReadOnlyChanged,
    required this.onAddMemberChanged,
    required this.onShareLinkChanged,
    required this.checkPermission,
  });
  List<ScheduleGuest> guests;
  void Function(dynamic)? onRemove;
  void Function(int, bool) onReadOnlyChanged;
  void Function(int, bool) onAddMemberChanged;
  void Function(int, bool) onShareLinkChanged;
  bool Function(int, SchedulePermission) checkPermission;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: guests.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        ScheduleGuest item = guests[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (index > 0)
              SizedBox(
                height: RegularSize.s,
              ),
            _GuestListItem(
              guest: item,
              removable: true,
              onRemove: onRemove,
            ),
            Obx(() {
              bool readOnlyValue = checkPermission(item.scheuserid ?? 0, SchedulePermission.readOnly);
              bool addMemberValue = checkPermission(item.scheuserid ?? 0, SchedulePermission.addMember);
              bool shareLinkValue = checkPermission(item.scheuserid ?? 0, SchedulePermission.shareLink);
              return Row(
                children: [
                  Expanded(
                    child: _ReadOnlyCheckbox(
                      onChecked: (value) => onReadOnlyChanged(item.scheuserid ?? 0, value),
                      value: readOnlyValue,
                    ),
                  ),
                  Expanded(
                    child: _SharelinkCheckbox(
                      onChecked: (value) => onShareLinkChanged(item.scheuserid ?? 0, value),
                      enabled: !readOnlyValue,
                      value: shareLinkValue,
                    ),
                  ),
                  Expanded(
                    child: _AddmemberCheckbox(
                      onChecked: (value) => onAddMemberChanged(item.scheuserid ?? 0, value),
                      enabled: !readOnlyValue,
                      value: addMemberValue,
                    ),
                  ),
                ],
              );
            }),
            SizedBox(
              height: RegularSize.s,
            ),
          ],
        );
      },
    );
  }
}
