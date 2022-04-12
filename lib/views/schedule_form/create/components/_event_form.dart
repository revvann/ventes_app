// ignore_for_file: prefer_const_constructors

part of 'package:ventes/views/schedule_form/create/schedule_fc.dart';

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
          controller: controller.dateStartTEC,
          initialDate: controller.formSource.dateStart,
          onSelected: controller.formSource.onDateStartSelected,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _DateendInput(
            controller: controller.dateEndTEC,
            initialDate: controller.formSource.dateEnd,
            onSelected: controller.formSource.onDateEndSelected,
            minDate: controller.formSource.dateStart,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _TwintimeInput(
          onTimeEndSelected: controller.formSource.onTimeEndSelected,
          onTimeStartSelected: controller.formSource.onTimeStartSelected,
          timeStartController: controller.timeStartSelectController,
          timeEndController: controller.timeEndSelectController,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _AlldayCheckbox(
          onChecked: controller.formSource.allDayToggle,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        GestureDetector(
          onTap: () {
            if (!controller.formSource.online) {
              controller.showMapBottomSheet();
            }
          },
          child: _LocationInput(controller: controller.locationTEC),
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _OnlineCheckbox(
          onChecked: controller.formSource.onlineToggle,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _LinkInput(
            controller: controller.linkTEC,
            enabled: controller.formSource.online,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        _RemindInput(controller: controller.remindTEC),
        SizedBox(
          height: RegularSize.m,
        ),
        _DescriptionInput(controller: controller.descriptionTEC),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return _GuestDropdown(
            guests: controller.guests,
            onChanged: controller.formSource.onGuestChanged,
            dropdownKey: controller.dropdownKey,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return Column(
            children: [
              if (controller.formSource.guestsSelected.isNotEmpty)
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Selected Guests",
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
                guests: controller.formSource.guestsSelected,
                onRemove: controller.formSource.onRemoveGuest,
              ),
            ],
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return Column(
            children: [
              if (controller.formSource.guestsSelected.isNotEmpty)
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Guest Permission",
                    style: TextStyle(
                      fontSize: 12,
                      color: RegularColor.dark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(
                height: RegularSize.m,
              ),
              if (controller.formSource.guestsSelected.isNotEmpty)
                Row(
                  children: [
                    Obx(() {
                      return Expanded(
                        child: _ReadOnlyCheckbox(
                          onChecked: controller.formSource.readOnlyToggle,
                          value: controller.formSource.guestPermission.contains(controller.formSource.readOnlyId),
                        ),
                      );
                    }),
                    Obx(() {
                      return Expanded(
                        child: _SharelinkCheckbox(
                          onChecked: controller.formSource.shareLinkToggle,
                          enabled: !controller.formSource.guestPermission.contains(controller.formSource.readOnlyId),
                          value: controller.formSource.guestPermission.contains(controller.formSource.shareLinkId),
                        ),
                      );
                    }),
                    Obx(() {
                      return Expanded(
                        child: _AddmemberCheckbox(
                          onChecked: controller.formSource.addMemberToggle,
                          enabled: !controller.formSource.guestPermission.contains(controller.formSource.readOnlyId),
                          value: controller.formSource.guestPermission.contains(controller.formSource.addMemberId),
                        ),
                      );
                    }),
                  ],
                ),
            ],
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
      ],
    );
  }
}
