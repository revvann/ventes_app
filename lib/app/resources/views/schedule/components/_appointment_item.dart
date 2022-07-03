// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/schedule/schedule.dart';

class _AppointmentItem extends StatelessWidget {
  _AppointmentItem({required this.appointment, required this.onFindColor});
  Schedule appointment;
  Color Function(Schedule appointment) onFindColor;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      MaterialColor colors = Utils.createSwatch(onFindColor(appointment));

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: RegularSize.m,
          vertical: RegularSize.s,
        ),
        margin: EdgeInsets.only(bottom: RegularSize.s),
        decoration: BoxDecoration(
          color: colors.shade100,
          borderRadius: BorderRadius.circular(RegularSize.m),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    appointment.schenm ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.shade500,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (appointment.scheloc != null)
              Text(
                appointment.scheloc!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: colors.shade500,
                  fontSize: 10,
                ),
              ),
            SizedBox(
              height: RegularSize.xs,
            ),
            Text(
              appointment.schebp?.bpname ?? "",
              style: TextStyle(
                color: RegularColor.dark,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    });
  }
}
