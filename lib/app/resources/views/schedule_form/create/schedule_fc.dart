// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/editor_input.dart';
import 'package:ventes/app/resources/widgets/handler_container.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/prospect_card.dart';
import 'package:ventes/app/resources/widgets/regular_checkbox.dart';
import 'package:ventes/app/resources/widgets/regular_date_picker.dart';
import 'package:ventes/app/resources/widgets/regular_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/regular_select_box.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/schedule_fc_state_controller.dart';
import 'package:ventes/app/states/form/sources/schedule_fc_form_source.dart';
import 'package:ventes/app/states/typedefs/schedule_fc_typedef.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/core/view/view.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';

part 'package:ventes/app/resources/views/schedule_form/create/components/_addmember_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_allday_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_dateend_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_datestart_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_description_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_event_form.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_guest_dropdown.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_guest_item.dart';
part "package:ventes/app/resources/views/schedule_form/create/components/_guest_list.dart";
part 'package:ventes/app/resources/views/schedule_form/create/components/_link_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_location_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_online_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_private_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_readonly_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_remind_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_reminder_form.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_scheduletype_selectbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_sharelink_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_starttime_dropdown.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_task_form.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_timezone_dropdown.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_title_input.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_toward_dropdown.dart';
part 'package:ventes/app/resources/views/schedule_form/create/components/_twintime_input.dart';

class ScheduleFormCreateView extends View<Controller> {
  static const String route = "/schedule/create";
  DateTime? startDate;
  int? refTypeId;
  int? refId;
  Map<String, dynamic>? refData;

  ScheduleFormCreateView({this.startDate, this.refTypeId, this.refId, this.refData});

  @override
  void onBuild(state) {
    state.formSource.schestartdate = startDate;
    state.formSource.schereftypeid = refTypeId;
    state.formSource.scherefid = refId;
    state.property.refData = refData;
  }

  @override
  Widget buildWidget(BuildContext context, state) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        title: ScheduleString.appBarTitle,
        onTitleTap: () async => state.refreshStates(),
        appBarKey: state.appBarKey,
        leading: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(RegularSize.xs),
            child: SvgPicture.asset(
              "assets/svg/arrow-left.svg",
              width: RegularSize.xl,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Get.back(id: ScheduleNavigator.id);
          },
        ),
        actions: [
          GestureDetector(
            onTap: state.listener.onFormSubmit,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: RegularSize.s,
                horizontal: RegularSize.m,
              ),
              child: Text(
                ScheduleString.formCreateSubmitButton,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ).build(context),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: RegularSize.m,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(RegularSize.xl),
              topRight: Radius.circular(RegularSize.xl),
            ),
          ),
          child: Form(
            key: state.formSource.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: RegularSize.l,
                ),
                Text(
                  "General",
                  style: TextStyle(
                    color: RegularColor.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: RegularSize.m,
                ),
                _TitleInput(
                  controller: state.formSource.schenmTEC,
                  validator: state.formSource.validator.schenm,
                ),
                SizedBox(
                  height: RegularSize.m,
                ),
                HandlerContainer<Function(List<Map<String, int>>)>(
                  handlers: [
                    state.dataSource.typesHandler,
                  ],
                  width: RegularSize.l,
                  builder: (data) => _ScheduletypeSelectbox(
                    onSelected: (value) {
                      state.formSource.schetype = value;
                    },
                    activeIndex: state.formSource.schetype,
                    items: state.dataSource.typeNames(),
                  ),
                ),
                SizedBox(
                  height: RegularSize.m,
                ),
                if (state.formSource.schereftypeid != null)
                  Obx(() {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              return Text(
                                state.property.referenceLabel,
                                style: TextStyle(
                                  color: RegularColor.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              );
                            }),
                            SizedBox(
                              height: RegularSize.l,
                              child: TextButton(
                                onPressed: state.listener.onHideClick,
                                child: Obx(() {
                                  return Text(
                                    state.property.toggleReferenceText,
                                    style: TextStyle(
                                      color: RegularColor.gray,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  );
                                }),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: RegularSize.xs,
                        ),
                        if (state.dataSource.refType?.typename == "Prospect Activity" && state.dataSource.prospect != null && state.property.hideReferenceField)
                          ProspectCard(
                            usePopup: false,
                            height: 100,
                            margin: EdgeInsets.only(
                              bottom: RegularSize.s,
                              top: RegularSize.s,
                            ),
                            name: state.dataSource.prospect?.prospectname ?? "",
                            customer: state.dataSource.prospect?.prospectcust?.sbccstmname ?? "",
                            owner: state.dataSource.prospect?.prospectowneruser?.user?.userfullname ?? "",
                            status: state.dataSource.prospect?.prospectstatus?.typename ?? "",
                            date: state.dataSource.prospect?.prospectstartdate ?? "",
                          ),
                      ],
                    );
                  }),
                SizedBox(
                  height: RegularSize.m,
                ),
                Text(
                  "More Options",
                  style: TextStyle(
                    color: RegularColor.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: HandlerContainer<Function(List<Map<String, int>>)>(
                    handlers: [
                      state.dataSource.typesHandler,
                    ],
                    width: RegularSize.xl,
                    builder: (data) => SingleChildScrollView(
                      child: Stack(
                        children: [
                          Offstage(
                            offstage: state.dataSource.typeName(state.formSource.schetype) != "Event",
                            child: _EventForm(),
                          ),
                          Offstage(
                            offstage: state.dataSource.typeName(state.formSource.schetype) != "Task",
                            child: _TaskForm(),
                          ),
                          Offstage(
                            offstage: state.dataSource.typeName(state.formSource.schetype) != "Reminder",
                            child: _ReminderForm(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
