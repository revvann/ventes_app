// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect_detail/prospect_detail.dart';

class _FloatingButton extends StatelessWidget {
  ProspectDetailStateController get state => Get.find<ProspectDetailStateController>();

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
        _buildChild('assets/svg/product-list.svg', "Products", state.listener.navigateToProduct),
        _buildChild(
          'assets/svg/contact.svg',
          "Contact",
          state.listener.navigateToContactPerson,
        ),
        _buildChild(
          'assets/svg/user.svg',
          "Assigned Users",
          state.listener.navigateToProspectAssign,
        ),
      ],
    );
  }

  SpeedDialChild _buildChild(String icon, String label, [Function()? onTap]) {
    return SpeedDialChild(
      child: SvgPicture.asset(
        icon,
        width: RegularSize.m,
        color: Colors.white,
      ),
      onTap: onTap,
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
