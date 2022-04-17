// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/schedule/schedule.dart';

class _AppointmentItem extends StatelessWidget {
  Schedule appointment;
  _AppointmentItem({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.m,
        vertical: RegularSize.s,
      ),
      margin: EdgeInsets.only(bottom: RegularSize.s),
      decoration: BoxDecoration(
        color: Color(0xffEFF5EF),
        borderRadius: BorderRadius.circular(RegularSize.m),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                appointment.schenm ?? "",
                style: TextStyle(
                  color: Color(0xffADC2AD),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: RegularSize.s,
                  vertical: RegularSize.xs,
                ),
                child: Text(
                  "On Site",
                  style: TextStyle(
                    color: RegularColor.gray,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (appointment.scheloc != null)
            Text(
              appointment.scheloc!,
              maxLines: 1,
              style: TextStyle(
                color: Color(0xffADC2AD),
                fontSize: 10,
              ),
            ),
          SizedBox(
            height: RegularSize.xs,
          ),
          Text(
            appointment.schedesc ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xffADC2AD),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
