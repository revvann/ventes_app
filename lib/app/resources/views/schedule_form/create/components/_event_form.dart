// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _EventForm extends StatelessWidget {
  _EventForm(this.controller);
  ScheduleFormCreateStateController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: RegularSize.m,
        ),
        _DatestartInput(
          controller: controller.formSource.schestartdateTEC,
          initialDate: controller.formSource.schestartdate,
          onSelected: controller.formSource.listener.onDateStartSelected,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _DateendInput(
            controller: controller.formSource.scheenddateTEC,
            initialDate: controller.formSource.scheenddate,
            onSelected: controller.formSource.listener.onDateEndSelected,
            minDate: controller.formSource.fullStartDate.add(Duration(minutes: 15)),
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _TwintimeInput(
          onTimeEndSelected: controller.formSource.listener.onTimeEndSelected,
          onTimeStartSelected: controller.formSource.listener.onTimeStartSelected,
          timeStartController: controller.formSource.schestarttimeDC,
          timeEndController: controller.formSource.scheendtimeDC,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _AlldayCheckbox(
          onChecked: controller.formSource.listener.onAlldayValueChanged,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        GestureDetector(
          onTap: () {
            if (!controller.formSource.scheonline) {
              controller.showMapBottomSheet();
            }
          },
          child: _LocationInput(
            controller: controller.formSource.schelocTEC,
            validator: controller.formSource.validator.scheloc,
          ),
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _OnlineCheckbox(
          onChecked: controller.formSource.listener.onOnlineValueChanged,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _LinkInput(
            controller: controller.formSource.scheonlinkTEC,
            enabled: controller.formSource.scheonline,
            validator: controller.formSource.validator.scheonlink,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _RemindInput(controller: controller.formSource.scheremindTEC),
        SizedBox(
          height: RegularSize.m,
        ),
        _DescriptionInput(controller: controller.formSource.schedescTEC),
        SizedBox(
          height: RegularSize.m,
        ),
        _GuestDropdown(
          onFilter: controller.dataSource.filterUser,
          onItemSelected: controller.formSource.listener.onGuestSelected,
          itemBuilder: (UserDetail user) {
            return Obx(
              () {
                List<ScheduleGuest> guestsSelected = controller.formSource.guests;
                bool isSelected = guestsSelected.where((g) => g.userid == user.userid).isNotEmpty;
                return _GuestListItem(
                  userDetail: user,
                  isSelected: isSelected,
                );
              },
            );
          },
        ),
        Obx(() {
          return controller.formSource.guests.isNotEmpty
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
                      guests: controller.formSource.guests,
                      onRemove: controller.formSource.listener.onRemoveGuest,
                      onAddMemberChanged: controller.formSource.listener.onAddMemberValueChanged,
                      onReadOnlyChanged: controller.formSource.listener.onReadOnlyValueChanged,
                      onShareLinkChanged: controller.formSource.listener.onShareLinkValueChanged,
                      checkPermission: controller.formSource.hasPermission,
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
