// ignore_for_file: prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/chat_home/chat_home.dart';

class _ChatItem extends StatelessWidget {
  String name;
  String bpname;
  bool isOnline;
  _ChatItem({required this.name, required this.bpname, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: RegularSize.s,
      ),
      height: 80,
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.m,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RegularSize.m),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 30,
            color: Color(0xFF0157E4).withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: Image.asset('assets/images/cat.png'),
            decoration: BoxDecoration(
              color: RegularColor.green,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: RegularSize.s,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: RegularColor.dark,
                  ),
                ),
                SizedBox(
                  height: RegularSize.s,
                ),
                Text(
                  bpname,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: RegularColor.gray,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: RegularSize.m),
              Text(
                isOnline ? "Online" : "Offline",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: isOnline ? RegularColor.green : RegularColor.gray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
