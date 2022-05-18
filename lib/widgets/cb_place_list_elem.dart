import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mobileapp_models/new_models/search/pm_place_details.dart';
import 'package:mobileapp_utils/resources/party_gradients.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:mobileapp_icons/p_app_icons_icons.dart';

class CBPlaceListElem extends StatelessWidget {
  final ValueChanged<PMPlaceDetails>? onTap;
  final PMPlaceDetails suggestion;
  final bool filled;
  final IconData? icon;
  final Widget? suffixWidget;
  final bool outlined;
  final Color? borderColor;
  final Color? iconColor;

  const CBPlaceListElem({
    Key? key,
    required this.suggestion,
    this.filled = false,
    this.onTap,
    this.icon,
    this.suffixWidget,
    this.outlined = true,
    this.borderColor,
    this.iconColor,
  }) : super(key: key);

  _buildIcon() {
    return SizedBox(
      width: PSizeConfig.width(47),
      height: PSizeConfig.height(47),
      child: Container(
        width: PSizeConfig.width(42),
        height: PSizeConfig.height(42),
        decoration: outlined
            ? BoxDecoration(
                shape: BoxShape.circle,
                gradient: filled ? PGradients.grad1() : null,
                border: filled
                    ? null
                    : Border.all(
                        color: borderColor ?? HexColor("F7903D"),
                        width: 1.3,
                      ),
              )
            : null,
        child: Center(
          child: Icon(
            icon ?? PAppIcons.location_filled,
            size: 24,
            color: iconColor ?? (filled ? Colors.white : HexColor("F7903D")),
          ),
        ),
      ),
    );
  }

  _buildTitle() {
    return Text(
      suggestion.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.workSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: HexColor('2B2B2B'),
      ),
    );
  }

  _buildSubTitle() {
    return Container(
      margin: EdgeInsets.only(top: PSizeConfig.height(3)),
      child: Text(
        suggestion.description!,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.workSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: HexColor('2B2B2B'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (Platform.isIOS) await HapticFeedback.lightImpact();
        FocusManager.instance.primaryFocus?.unfocus();
        onTap?.call(suggestion);
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: PSizeConfig.width(20),
          vertical: PSizeConfig.height(10),
        ),
        child: Row(
          children: [
            _buildIcon(),
            PSizeConfig.widthSpace(12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  if (suggestion.description != null) _buildSubTitle(),
                ],
              ),
            ),
            if (suffixWidget != null) suffixWidget!
          ],
        ),
      ),
    );
  }
}
