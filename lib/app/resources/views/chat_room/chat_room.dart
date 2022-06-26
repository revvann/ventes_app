// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/handler_container.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/properties/chat_room_property.dart';
import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/core/view/view.dart';
import 'package:ventes/helpers/function_helpers.dart';

part 'package:ventes/app/resources/views/chat_room/components/_chat_body.dart';
part 'package:ventes/app/resources/views/chat_room/components/_chat_header.dart';
part 'package:ventes/app/resources/views/chat_room/components/_chat_input.dart';

class ChatRoomView extends View<Controller> {
  static const String route = "/chatroom";

  @override
  void onBuild(state) {}

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
        height: 80,
        title: DashboardString.chatAppBarTitle,
        appBarKey: state.appBarKey,
        onTitleTap: () async => state.refreshStates(),
        leading: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(RegularSize.xs),
            child: SvgPicture.asset(
              "assets/svg/arrow-left.svg",
              width: RegularSize.xl,
              color: Colors.white,
            ),
          ),
          onTap: state.listener.goBack,
        ),
        below: Container(
          padding: EdgeInsets.symmetric(
            horizontal: RegularSize.xl,
          ),
          alignment: Alignment.center,
          child: HandlerContainer<Function(UserDetail?)>(
            handlers: [
              state.dataSource.userDetailHandler,
            ],
            builder: (userDetail) => Text(
              userDetail?.user?.userfullname ?? "Unknown",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ).build(context),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: RegularSize.xl,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(RegularSize.xl),
              topRight: Radius.circular(RegularSize.xl),
            ),
          ),
          child: Column(
            children: [
              Obx(() {
                return Expanded(
                  child: GroupedListView<Chat, DateTime>(
                    order: GroupedListOrder.DESC,
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: RegularSize.s),
                    elements: state.property.chats,
                    groupBy: (chat) => DateTime(chat.date.year, chat.date.month, chat.date.day),
                    groupHeaderBuilder: (Chat chat) => _ChatHeader(formatDate(chat.date)),
                    itemBuilder: (_, chat) {
                      return _ChatBody(chat.message, isMe: chat.deviceid == state.dataSource.userDetail?.user?.userdeviceid);
                    },
                  ),
                );
              }),
              Container(
                margin: EdgeInsets.only(
                  top: RegularSize.s,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: RegularSize.m,
                  vertical: RegularSize.m,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(RegularSize.xl),
                    topRight: Radius.circular(RegularSize.xl),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 30,
                      color: Color(0xFF0157E4).withOpacity(0.1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _ChatInput(
                        hintText: "Message...",
                        controller: state.property.messageTEC,
                      ),
                    ),
                    GestureDetector(
                      onTap: state.listener.onSend,
                      child: Container(
                        padding: EdgeInsets.all(RegularSize.s),
                        child: SvgPicture.asset(
                          'assets/svg/send.svg',
                          color: RegularColor.gray,
                          width: RegularSize.l,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
