// ignore_for_file: prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/chat_room/chat_room.dart';

class _FileCard extends StatelessWidget {
  Controller state = Get.find<Controller>();
  PlatformFile file;

  _FileCard(this.file);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.m,
        vertical: RegularSize.s,
      ),
      decoration: BoxDecoration(
        color: RegularColor.gray.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(RegularSize.xl)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/file-fill.svg',
            color: RegularColor.gray,
            width: RegularSize.l,
            height: RegularSize.l,
          ),
          SizedBox(
            width: RegularSize.m,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  file.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: RegularColor.dark,
                  ),
                ),
                SizedBox(
                  height: RegularSize.xs,
                ),
                Text(
                  lookupMimeType(file.path!) ?? "-",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: RegularColor.dark,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: RegularSize.m,
          ),
          Text(
            state.property.sizeShort(file.size),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: RegularColor.gray,
            ),
          ),
          SizedBox(
            width: RegularSize.s,
          ),
          Material(
            shape: CircleBorder(),
            child: InkWell(
              customBorder: CircleBorder(),
              splashColor: Colors.white.withOpacity(0.1),
              highlightColor: Colors.white.withOpacity(0.1),
              hoverColor: Colors.white.withOpacity(0.1),
              focusColor: Colors.white.withOpacity(0.1),
              onTap: state.listener.onDeleteFileClicked,
              child: Ink(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: RegularColor.red,
                ),
                width: RegularSize.l,
                height: RegularSize.l,
                padding: EdgeInsets.all(RegularSize.s),
                child: SvgPicture.asset(
                  'assets/svg/close.svg',
                  color: Colors.white,
                  width: RegularSize.m,
                  height: RegularSize.m,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
