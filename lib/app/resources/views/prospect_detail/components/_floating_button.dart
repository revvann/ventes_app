// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect_detail/prospect_detail.dart';

class _FloatingButton extends StatelessWidget {
  const _FloatingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      child: SvgPicture.asset(
        'assets/svg/menu-list.svg',
        width: RegularSize.l,
        color: Colors.white,
      ),
      backgroundColor: RegularColor.primary,
      overlayOpacity: 0,
      spacing: RegularSize.s,
      children: [
        _buildChild('assets/svg/daily-visit.svg', "Visit"),
        _buildChild('assets/svg/contact.svg', "Contact"),
        _buildChild('assets/svg/plus.svg', "Add Detail"),
      ],
    );
  }

  SpeedDialChild _buildChild(String icon, String label) {
    return SpeedDialChild(
      child: SvgPicture.asset(
        icon,
        width: RegularSize.m,
        color: Colors.white,
      ),
      backgroundColor: RegularColor.primary,
      labelShadow: [
        BoxShadow(
          color: Color(0xFF0157E4).withOpacity(0.1),
          spreadRadius: 0,
          blurRadius: 30,
          offset: Offset(0, 4),
        ),
      ],
      labelWidget: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: RegularSize.xs,
          horizontal: RegularSize.s,
        ),
        decoration: BoxDecoration(
          color: RegularColor.dark,
          borderRadius: BorderRadius.circular(RegularSize.xs),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
