part of 'package:ventes/app/resources/views/chat_room/chat_room.dart';

class _ChatHeader extends StatelessWidget {
  String text;
  _ChatHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: RegularSize.s,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: RegularSize.s,
          vertical: RegularSize.xs,
        ),
        decoration: BoxDecoration(
          color: RegularColor.primary,
          borderRadius: BorderRadius.circular(RegularSize.s),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
