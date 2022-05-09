// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _EventForm extends StatelessWidget {
  ScheduleFormCreateStateController $ = Get.find<ScheduleFormCreateStateController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _DatestartInput(
            controller: $.schestartdateTEC,
            initialDate: $.schestartdate,
            onSelected: $.onDateStartSelected,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _DateendInput(
            controller: $.scheenddateTEC,
            initialDate: $.scheenddate,
            onSelected: $.onDateEndSelected,
            minDate: $.fullStartDate.add(Duration(minutes: 15)),
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _TwintimeInput(
          onTimeEndSelected: $.onTimeEndSelected,
          onTimeStartSelected: $.onTimeStartSelected,
          timeStartController: $.schestarttimeDC,
          timeEndController: $.scheendtimeDC,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _TimezoneDropdown(
          controller: $.schetzDC,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _AlldayCheckbox(
          onChecked: $.onAlldayValueChanged,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        GestureDetector(
          onTap: () {
            if (!$.scheonline) {
              $.showMapBottomSheet();
            }
          },
          child: _LocationInput(
            controller: $.schelocTEC,
            validator: $.validator.scheloc,
          ),
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _OnlineCheckbox(
          onChecked: $.onOnlineValueChanged,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _LinkInput(
            controller: $.scheonlinkTEC,
            enabled: $.scheonline,
            validator: $.validator.scheonlink,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _RemindInput(controller: $.scheremindTEC),
        SizedBox(
          height: RegularSize.m,
        ),
        _DescriptionInput(controller: $.schedescTEC),
        SizedBox(
          height: RegularSize.m,
        ),
        _PrivateCheckbox(onChecked: $.onPrivateValueChanged),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _TowardDropdown(
            selected: $.schetoward?.user?.userfullname,
            onFilter: $.onTowardFilter,
            onItemSelected: $.onTowardSelected,
            itemBuilder: (UserDetail user) {
              return Obx(
                () {
                  bool isSelected = $.schetoward?.userid == user.userid;
                  return _GuestListItem(
                    userDetail: user,
                    isSelected: isSelected,
                  );
                },
              );
            },
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _GuestDropdown(
          onFilter: $.onGuestFilter,
          onItemSelected: $.onGuestSelected,
          itemBuilder: (UserDetail user) {
            return Obx(
              () {
                List<ScheduleGuest> guestsSelected = $.guests;
                bool isSelected = guestsSelected.where((g) => g.scheuserid == user.userid).isNotEmpty;
                return _GuestListItem(
                  userDetail: user,
                  isSelected: isSelected,
                );
              },
            );
          },
        ),
        Obx(() {
          return $.guests.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(
                      height: RegularSize.m,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ScheduleString.selectedGuestLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: RegularColor.dark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: RegularSize.s,
                    ),
                    _GuestList(
                      guests: $.guests,
                      onRemove: $.onRemoveGuest,
                      onAddMemberChanged: $.onAddMemberValueChanged,
                      onReadOnlyChanged: $.onReadOnlyValueChanged,
                      onShareLinkChanged: $.onShareLinkValueChanged,
                      checkPermission: $.hasPermission,
                    ),
                  ],
                )
              : Container();
        }),
        SizedBox(
          height: RegularSize.m,
        ),
      ],
    );
  }
}
