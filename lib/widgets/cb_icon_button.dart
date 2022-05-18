import 'package:flutter/material.dart';

class CBIconButton extends StatelessWidget {
  final Color? color;
  final IconData? icon;
  final VoidCallback? onTap;

  const CBIconButton({
    Key? key,
    this.color,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: color ?? Colors.black,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      disabledColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: onTap,
      icon: Icon(icon),
    );
  }
}
