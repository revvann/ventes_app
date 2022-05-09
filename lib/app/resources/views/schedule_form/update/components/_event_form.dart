// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/resources/views/schedule_form/update/schedule_fu.dart';

class _EventForm extends StatelessWidget {
  ScheduleFormUpdateStateController state = Get.find<ScheduleFormUpdateStateController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _DatestartInput(
            controller: state.formSource.schestartdateTEC,
            initialDate: state.formSource.schestartdate,
            onSelected: state.listener.onDateStartSelected,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _DateendInput(
            controller: state.formSource.scheenddateTEC,
            initialDate: state.formSource.scheenddate,
            onSelected: state.listener.onDateEndSelected,
            minDate: state.formSource.fullStartDate.add(Duration(minutes: 15)),
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _TwintimeInput(
          onTimeEndSelected: state.listener.onTimeEndSelected,
          onTimeStartSelected: state.listener.onTimeStartSelected,
          timeStartController: state.formSource.schestarttimeDC,
          timeEndController: state.formSource.scheendtimeDC,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _TimezoneDropdown(
          controller: state.formSource.schetzDC,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _AlldayCheckbox(
            value: state.formSource.scheallday,
            onChecked: state.listener.onAlldayValueChanged,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        GestureDetector(
          onTap: () {
            if (!state.formSource.scheonline) {
              state.properties.showMapBottomSheet();
            }
          },
          child: _LocationInput(
            controller: state.formSource.schelocTEC,
            validator: state.formSource.validator.scheloc,
          ),
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _OnlineCheckbox(
            value: state.formSource.scheonline,
            onChecked: state.listener.onOnlineValueChanged,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _LinkInput(
            controller: state.formSource.scheonlinkTEC,
            enabled: state.formSource.scheonline,
            validator: state.formSource.validator.scheonlink,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _RemindInput(controller: state.formSource.scheremindTEC),
        SizedBox(
          height: RegularSize.m,
        ),
        _DescriptionInput(controller: state.formSource.schedescTEC),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _PrivateCheckbox(onChecked: state.listener.onPrivateValueChanged, value: state.formSource.scheprivate);
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _TowardDropdown(
            selected: state.formSource.schetoward?.user?.userfullname,
            onFilter: state.listener.onTowardFilter,
            onItemSelected: state.listener.onTowardSelected,
            itemBuilder: (UserDetail user) {
              return Obx(
                () {
                  bool isSelected = state.formSource.schetoward?.userid == user.userid;
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
          onFilter: state.listener.onGuestFilter,
          onItemSelected: state.listener.onGuestSelected,
          itemBuilder: (UserDetail user) {
            return Obx(
              () {
                List<ScheduleGuest> guestsSelected = state.formSource.guests;
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
          return state.formSource.guests.isNotEmpty
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
                      guests: state.formSource.guests,
                      onRemove: state.listener.onRemoveGuest,
                      onAddMemberChanged: state.listener.onAddMemberValueChanged,
                      onReadOnlyChanged: state.listener.onReadOnlyValueChanged,
                      onShareLinkChanged: state.listener.onShareLinkValueChanged,
                      checkPermission: state.formSource.hasPermission,
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
