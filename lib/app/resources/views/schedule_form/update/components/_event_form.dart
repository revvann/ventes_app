// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _EventForm extends StatelessWidget {
  ScheduleFormUpdateStateController $ = Get.find<ScheduleFormUpdateStateController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _DatestartInput(
            controller: $.formSource.schestartdateTEC,
            initialDate: $.formSource.schestartdate,
            onSelected: $.listener.onDateStartSelected,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _DateendInput(
            controller: $.formSource.scheenddateTEC,
            initialDate: $.formSource.scheenddate,
            onSelected: $.listener.onDateEndSelected,
            minDate: $.formSource.fullStartDate.add(Duration(minutes: 15)),
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _TwintimeInput(
          onTimeEndSelected: $.listener.onTimeEndSelected,
          onTimeStartSelected: $.listener.onTimeStartSelected,
          timeStartController: $.formSource.schestarttimeDC,
          timeEndController: $.formSource.scheendtimeDC,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _TimezoneDropdown(
          controller: $.formSource.schetzDC,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _AlldayCheckbox(
            value: $.formSource.scheallday,
            onChecked: $.listener.onAlldayValueChanged,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        GestureDetector(
          onTap: () {
            if (!$.formSource.scheonline) {
              $.showMapBottomSheet();
            }
          },
          child: _LocationInput(
            controller: $.formSource.schelocTEC,
            validator: $.formSource.validator.scheloc,
          ),
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _OnlineCheckbox(
            value: $.formSource.scheonline,
            onChecked: $.listener.onOnlineValueChanged,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _LinkInput(
            controller: $.formSource.scheonlinkTEC,
            enabled: $.formSource.scheonline,
            validator: $.formSource.validator.scheonlink,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _RemindInput(controller: $.formSource.scheremindTEC),
        SizedBox(
          height: RegularSize.m,
        ),
        _DescriptionInput(controller: $.formSource.schedescTEC),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _PrivateCheckbox(onChecked: $.listener.onPrivateValueChanged, value: $.formSource.scheprivate);
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _TowardDropdown(
            selected: $.formSource.schetoward?.user?.userfullname,
            onFilter: $.listener.onTowardFilter,
            onItemSelected: $.listener.onTowardSelected,
            itemBuilder: (UserDetail user) {
              return Obx(
                () {
                  bool isSelected = $.formSource.schetoward?.userid == user.userid;
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
          onFilter: $.listener.onGuestFilter,
          onItemSelected: $.listener.onGuestSelected,
          itemBuilder: (UserDetail user) {
            return Obx(
              () {
                List<ScheduleGuest> guestsSelected = $.formSource.guests;
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
          return $.formSource.guests.isNotEmpty
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
                      guests: $.formSource.guests,
                      onRemove: $.listener.onRemoveGuest,
                      onAddMemberChanged: $.listener.onAddMemberValueChanged,
                      onReadOnlyChanged: $.listener.onReadOnlyValueChanged,
                      onShareLinkChanged: $.listener.onShareLinkValueChanged,
                      checkPermission: $.formSource.hasPermission,
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
