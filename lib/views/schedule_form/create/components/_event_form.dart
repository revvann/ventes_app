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
          controller: controller.formSource.schestartdateTEC,
          initialDate: controller.formSource.schestartdate,
          onSelected: controller.formSource.onDateStartSelected,
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx( () {
            return _DateendInput(
              controller: controller.formSource.scheenddateTEC,
              initialDate: controller.formSource.scheenddate,
              onSelected: controller.formSource.onDateEndSelected,
              minDate: controller.formSource.schestartdate,
            );
          }
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _TwintimeInput(
          onTimeEndSelected: controller.formSource.onTimeEndSelected,
          onTimeStartSelected: controller.formSource.onTimeStartSelected,
          timeStartController: controller.formSource.schestarttimeDC,
          timeEndController: controller.formSource.scheendtimeDC,
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
            if (!controller.formSource.scheonline) {
              controller.showMapBottomSheet();
            }
          },
          child: _LocationInput(
            controller: controller.formSource.schelocTEC,
            validator: controller.formSource.schelocValidator,
          ),
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
            controller: controller.formSource.scheonlinkTEC,
            enabled: controller.formSource.scheonline,
            validator: controller.formSource.scheonlinkValidator,
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
        Obx(() {
          return _GuestDropdown(
            guests: controller.guests,
            onChanged: controller.formSource.onGuestChanged,
          );
        }),
        SizedBox(
          height: RegularSize.m,
        ),
        Obx(() {
          return Column(
            children: [
              if (controller.formSource.guests.isNotEmpty)
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
              if (controller.formSource.guests.isNotEmpty)
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ScheduleString.schepermisLabel,
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
              if (controller.formSource.guests.isNotEmpty)
                Row(
                  children: [
                    Obx(() {
                      return Expanded(
                        child: _ReadOnlyCheckbox(
                          onChecked: controller.formSource.readOnlyToggle,
                          value: controller.formSource.schepermisid.contains(controller.formSource.readOnlyId),
                        ),
                      );
                    }),
                    Obx(() {
                      return Expanded(
                        child: _SharelinkCheckbox(
                          onChecked: controller.formSource.shareLinkToggle,
                          enabled: !controller.formSource.schepermisid.contains(controller.formSource.readOnlyId),
                          value: controller.formSource.schepermisid.contains(controller.formSource.shareLinkId),
                        ),
                      );
                    }),
                    Obx(() {
                      return Expanded(
                        child: _AddmemberCheckbox(
                          onChecked: controller.formSource.addMemberToggle,
                          enabled: !controller.formSource.schepermisid.contains(controller.formSource.readOnlyId),
                          value: controller.formSource.schepermisid.contains(controller.formSource.addMemberId),
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
