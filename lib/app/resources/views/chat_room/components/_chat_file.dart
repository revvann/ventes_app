// ignore_for_file: prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/chat_room/chat_room.dart';

class _ChatFile extends StatelessWidget {
  Controller state = Get.find<Controller>();
  String filename;
  String? mimetype;
  int? filesize;
  bool isMe;

  _ChatFile({required this.filename, required this.mimetype, required this.filesize, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.s,
        vertical: RegularSize.s,
      ),
      decoration: BoxDecoration(
        color: isMe ? RegularColor.green.withOpacity(0.5) : RegularColor.gray.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(RegularSize.s)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: RegularSize.s,
              vertical: RegularSize.s,
            ),
            decoration: BoxDecoration(
              color: RegularColor.yellow,
              borderRadius: BorderRadius.all(Radius.circular(RegularSize.s)),
            ),
            child: SvgPicture.asset(
              'assets/svg/file-fill.svg',
              color: Colors.white,
              width: RegularSize.l,
              height: RegularSize.l,
            ),
          ),
          SizedBox(
            width: RegularSize.s,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  filename,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: RegularColor.dark,
                  ),
                ),
                SizedBox(
                  height: RegularSize.xs,
                ),
                Text(
                  mimetype ?? "-",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: RegularColor.dark,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: RegularSize.s,
          ),
          Text(
            state.property.sizeShort(filesize ?? 0),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: RegularColor.dark,
            ),
          ),
          // SizedBox(
          //   width: RegularSize.s,
          // ),
          // Material(
          //   shape: CircleBorder(),
          //   child: InkWell(
          //     customBorder: CircleBorder(),
          //     splashColor: Colors.white.withOpacity(0.1),
          //     highlightColor: Colors.white.withOpacity(0.1),
          //     hoverColor: Colors.white.withOpacity(0.1),
          //     focusColor: Colors.white.withOpacity(0.1),
          //     onTap: state.listener.onDeleteFileClicked,
          //     child: Ink(
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: RegularColor.green,
          //       ),
          //       width: RegularSize.l,
          //       height: RegularSize.l,
          //       padding: EdgeInsets.all(RegularSize.s),
          //       child: SvgPicture.asset(
          //         'assets/svg/close.svg',
          //         color: Colors.white,
          //         width: RegularSize.m,
          //         height: RegularSize.m,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
