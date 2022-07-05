part of 'package:ventes/app/resources/views/chat_room/chat_room.dart';

class _ChatBody extends StatelessWidget {
  int? userid;
  Chat chat;
  _ChatBody(
    this.chat, {
    required this.userid,
  });
  String get text => chat.chatmessage ?? "";
  String get time => Utils.formatTime12(Utils.dbParseDateTime(chat.createddate!));
  bool get isMe => chat.createdby == userid;
  bool get hasRead => chat.chatreadat != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: RegularSize.m,
            vertical: RegularSize.s,
          ),
          decoration: BoxDecoration(
              color: isMe ? RegularColor.green.withOpacity(0.5) : RegularColor.gray.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(RegularSize.s) : Radius.zero,
                topRight: Radius.circular(RegularSize.s),
                bottomRight: !isMe ? Radius.circular(RegularSize.s) : Radius.zero,
                bottomLeft: Radius.circular(RegularSize.s),
              )),
          child: Text(
            text,
            style: TextStyle(
              color: RegularColor.dark,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(
          height: RegularSize.xs,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              time,
              style: TextStyle(
                color: RegularColor.gray,
                fontSize: 10,
              ),
            ),
            if (isMe) ...[
              SizedBox(
                width: RegularSize.xs,
              ),
              Container(
                height: RegularSize.s,
                width: RegularSize.s,
                decoration: BoxDecoration(
                  color: hasRead ? RegularColor.green : RegularColor.gray,
                  shape: BoxShape.circle,
                ),
              ),
            ],
            SizedBox(width: 2),
          ],
        ),
        SizedBox(
          height: RegularSize.s,
        ),
      ],
    );
  }
}
