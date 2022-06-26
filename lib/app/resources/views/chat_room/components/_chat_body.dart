part of 'package:ventes/app/resources/views/chat_room/chat_room.dart';

class _ChatBody extends StatelessWidget {
  String text;
  bool isMe;
  _ChatBody(this.text, {this.isMe = true});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: RegularSize.xs,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: RegularSize.m,
          vertical: RegularSize.s,
        ),
        decoration: BoxDecoration(
            color: isMe ? RegularColor.green : RegularColor.gray.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: isMe ? Radius.circular(RegularSize.s) : Radius.zero,
              topRight: Radius.circular(RegularSize.s),
              bottomRight: !isMe ? Radius.circular(RegularSize.s) : Radius.zero,
              bottomLeft: Radius.circular(RegularSize.s),
            )),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? Colors.white : RegularColor.dark,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
