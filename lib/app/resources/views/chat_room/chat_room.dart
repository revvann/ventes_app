// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mime/mime.dart';
import 'package:ventes/app/api/models/chat_model.dart';
import 'package:ventes/app/api/models/files_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/handler_container.dart';
import 'package:ventes/app/resources/widgets/loading_container.dart';
import 'package:ventes/app/resources/widgets/top_navigation.dart';
import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/core/view/view.dart';
import 'package:ventes/utils/utils.dart';

part 'package:ventes/app/resources/views/chat_room/components/_chat_body.dart';
part 'package:ventes/app/resources/views/chat_room/components/_chat_file.dart';
part 'package:ventes/app/resources/views/chat_room/components/_chat_header.dart';
part 'package:ventes/app/resources/views/chat_room/components/_chat_input.dart';
part 'package:ventes/app/resources/views/chat_room/components/_file_card.dart';

class ChatRoomView extends View<Controller> {
  static const String route = "/chatroom";
  int id;

  ChatRoomView(this.id);

  @override
  void onBuild(state) {
    state.property.userid = id;
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
                    groupBy: (chat) => DateTime(Utils.dbParseDate(chat.createddate!).year, Utils.dbParseDate(chat.createddate!).month, Utils.dbParseDate(chat.createddate!).day),
                    groupHeaderBuilder: (Chat chat) => _ChatHeader(Utils.formatDate(Utils.dbParseDate(chat.createddate!))),
                    itemComparator: (chat1, chat2) => Utils.dbParseDateTime(chat1.createddate!).isAfter(Utils.dbParseDateTime(chat2.createddate!)) ? 1 : 0,
                    itemBuilder: (_, chat) {
                      return _ChatBody(chat, userid: state.dataSource.userDetail?.user?.userid);
                    },
                  ),
                );
              }),
              Container(
                margin: EdgeInsets.only(
                  top: RegularSize.s,
                ),
                padding: EdgeInsets.all(RegularSize.m),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() {
                      PlatformFile? file = state.property.chatFiles?.files.first;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (file != null) ...[
                            _FileCard(filename: file.name, filesize: file.size, mimetype: lookupMimeType(file.path!)),
                            SizedBox(height: RegularSize.xs),
                          ],
                        ],
                      );
                    }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _ChatInput(
                            hintText: "Message...",
                            controller: state.property.messageTEC,
                          ),
                        ),
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            customBorder: CircleBorder(),
                            splashColor: RegularColor.gray.withOpacity(0.1),
                            highlightColor: RegularColor.gray.withOpacity(0.1),
                            hoverColor: RegularColor.gray.withOpacity(0.1),
                            focusColor: RegularColor.gray.withOpacity(0.1),
                            onTap: state.listener.onPickFileClicked,
                            child: Ink(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              width: RegularSize.xl,
                              height: RegularSize.xl,
                              padding: EdgeInsets.all(RegularSize.s),
                              child: SvgPicture.asset(
                                'assets/svg/file.svg',
                                color: RegularColor.gray,
                                width: RegularSize.m,
                                height: RegularSize.m,
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            customBorder: CircleBorder(),
                            splashColor: RegularColor.green.withOpacity(0.1),
                            highlightColor: RegularColor.green.withOpacity(0.1),
                            hoverColor: RegularColor.green.withOpacity(0.1),
                            focusColor: RegularColor.green.withOpacity(0.1),
                            onTap: state.listener.sendMessage,
                            child: Ink(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              width: RegularSize.xl,
                              height: RegularSize.xl,
                              padding: EdgeInsets.all(RegularSize.s),
                              child: SvgPicture.asset(
                                'assets/svg/send.svg',
                                color: RegularColor.green,
                                width: RegularSize.m,
                                height: RegularSize.m,
                              ),
                            ),
                          ),
                        ),
                      ],
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
