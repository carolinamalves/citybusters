import 'dart:io';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CBOrangeButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;

  const CBOrangeButton({
    Key? key,
    this.onTap,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Platform.isIOS) HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        constraints: BoxConstraints(
          minWidth: PSizeConfig.width(150),
          minHeight: PSizeConfig.height(47),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: PSizeConfig.width(20),
          vertical: PSizeConfig.height(12),
        ),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (text != null)
              Flexible(
                child: Text(
                  text!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
