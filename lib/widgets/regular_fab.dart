import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/state_controllers/fab_state_controller.dart';
import 'package:ventes/views/regular_view.dart';

class RegularFAB extends RegularView<FABStateController> {
  void Function() onAddClick;
  void Function() onEditClick;
  void Function() onDeleteClick;

  RegularFAB({required this.onAddClick, required this.onEditClick, required this.onDeleteClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildFAB(
            'delete',
            'assets/svg/delete.svg',
            RegularColor.red,
            onDeleteClick,
          ),
          _buildFAB(
            'edit',
            'assets/svg/edit.svg',
            RegularColor.secondary,
            onEditClick,
          ),
          _buildFAB(
            'plus',
            'assets/svg/plus.svg',
            RegularColor.primary,
            onAddClick,
          ),
          SizedBox(
            width: RegularSize.xxl,
            height: RegularSize.xxl,
            child: FittedBox(
              child: FloatingActionButton(
                elevation: 6,
                onPressed: $.toggleFAB,
                backgroundColor: RegularColor.gray,
                child: Obx(() {
                  return SvgPicture.asset(
                    $.isShown ? 'assets/svg/close.svg' : 'assets/svg/more.svg',
                    color: Colors.white,
                    width: RegularSize.l,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(String prop, String icon, Color color, void Function() onclick) {
    return AnimatedBuilder(
      animation: $.fabPosition,
      builder: (_, __) => Positioned(
        bottom: $.fabPosition.value.get(prop),
        child: SizedBox(
          width: RegularSize.xxl,
          height: RegularSize.xxl,
          child: FittedBox(
            child: Obx(() {
              return FloatingActionButton(
                elevation: $.isShown ? 10 : 0,
                onPressed: onclick,
                backgroundColor: color,
                child: SvgPicture.asset(
                  icon,
                  color: Colors.white,
                  width: RegularSize.l,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
