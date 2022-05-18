import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileapp_icons/p_app_icons_icons.dart';

enum CBAppBarLeading { back }

class CBAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? bgColor;
  final SystemUiOverlayStyle? style;
  final MapEntry<CBAppBarLeading, VoidCallback?>? leading;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  const CBAppBar({
    Key? key,
    this.leading,
    this.title,
    this.style,
    this.bgColor,
  }) : super(key: key);

  _buildButton(IconData icon, {VoidCallback? onTap}) {
    return IconButton(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      color: Colors.transparent,
      onPressed: onTap,
      icon: Icon(icon, color: Colors.black),
    );
  }

  Widget? _getLeading() {
    switch (leading?.key) {
      case CBAppBarLeading.back:
        return _buildButton(
          PAppIcons.arrow_left,
          onTap: leading?.value ?? Get.back,
        );
      default:
        return null;
    }
  }

  Widget? _getTitle() {
    if (title != null) {
      return Text(
        title!,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor ?? Colors.white,
      elevation: 0,
      leading: _getLeading(),
      title: _getTitle(),
      systemOverlayStyle: style ?? SystemUiOverlayStyle.dark,
    );
  }
}
