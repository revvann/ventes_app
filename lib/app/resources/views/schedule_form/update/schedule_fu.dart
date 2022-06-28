// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/editor_input.dart';
import 'package:ventes/app/resources/widgets/handler_container.dart';
import 'package:ventes/app/resources/widgets/icon_input.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_checkbox.dart';
import 'package:ventes/app/resources/widgets/regular_date_picker.dart';
import 'package:ventes/app/resources/widgets/regular_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_input.dart';
import 'package:ventes/app/resources/widgets/regular_select_box.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/controllers/schedule_fu_state_controller.dart';
import 'package:ventes/app/states/form/sources/schedule_fu_form_source.dart';
import 'package:ventes/app/states/typedefs/schedule_fu_typedef.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/core/view/view.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';

part 'package:ventes/app/resources/views/schedule_form/update/components/_addmember_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_allday_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_dateend_input.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_datestart_input.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_description_input.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_event_form.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_guest_dropdown.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_guest_item.dart';
part "package:ventes/app/resources/views/schedule_form/update/components/_guest_list.dart";
part 'package:ventes/app/resources/views/schedule_form/update/components/_link_input.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_location_input.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_online_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_private_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_readonly_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_remind_input.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_reminder_form.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_scheduletype_selectbox.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_sharelink_checkbox.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_starttime_dropdown.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_task_form.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_timezone_dropdown.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_title_input.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_toward_dropdown.dart';
part 'package:ventes/app/resources/views/schedule_form/update/components/_twintime_input.dart';

class ScheduleFormUpdateView extends View<Controller> {
  static const String route = "/schedule/update";
  int scheduleId;

  ScheduleFormUpdateView({required this.scheduleId});

  @override
  void onBuild(state) {
    state.dataSource.scheduleId = scheduleId;
  }

  @override
  Widget buildWidget(BuildContext context, state) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: RegularColor.primary,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: RegularColor.primary,
      extendBodyBehindAppBar: true,
      appBar: TopNavigation(
        onTitleTap: () async => state.refreshStates(),
        title: ScheduleString.appBarTitle,
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
                ScheduleString.formUpdateSubmitButton,
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
                HandlerContainer<Function(Schedule?)>(
                  handlers: [
                    state.dataSource.scheduleHandler,
                  ],
                  width: RegularSize.l,
                  builder: (data) => Obx(() {
                    return _ScheduletypeSelectbox(
                      onSelected: (value) {
                        state.formSource.schetype = value;
                      },
                      activeIndex: state.formSource.schetype,
                      items: state.dataSource.typeName(state.formSource.schetype) != null ? [state.dataSource.typeName(state.formSource.schetype)!] : [],
                    );
                  }),
                ),
                SizedBox(
                  height: RegularSize.l,
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
                  child: HandlerContainer<Function(List<Map<String, int>>, Schedule?)>(
                    handlers: [
                      state.dataSource.typesHandler,
                      state.dataSource.scheduleHandler,
                    ],
                    width: RegularSize.xl,
                    builder: (data, schedule) => SingleChildScrollView(
                      child: Obx(() {
                        return Stack(
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
                        );
                      }),
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
