part of 'package:ventes/app/resources/views/chat_home/chat_home.dart';

class _ChatList extends StatelessWidget {
  ChatHomeStateController state = Get.find<ChatHomeStateController>();

  @override
  Widget build(BuildContext context) {
    return HandlerContainer<Function(List<UserDetail>)>(
      handlers: [
        state.dataSource.usersHandler,
      ],
      width: RegularSize.xl,
      builder: (users) => ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: RegularSize.m,
        ),
        itemCount: users.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          UserDetail user = users[index];
          return GestureDetector(
            onTap: () => state.listener.onChatClick(user.userid),
            child: _ChatItem(name: user.user?.userfullname ?? "Unknown", bpname: user.businesspartner?.bpname ?? "-", isOnline: state.dataSource.usersActive.contains(user.user?.usersocketid)),
          );
        },
      ),
    );
  }
}
