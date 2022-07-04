part of 'package:ventes/app/resources/views/chat_room/chat_room.dart';

class _ChatBody extends StatelessWidget {
  String text;
  String time;
  bool isMe;
  _ChatBody(
    this.text, {
    required this.time,
    this.isMe = true,
  });

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
        Text(
          time,
          style: TextStyle(
            color: RegularColor.gray,
            fontSize: 10,
          ),
        ),
        SizedBox(
          height: RegularSize.s,
        ),
      ],
    );
  }
}
