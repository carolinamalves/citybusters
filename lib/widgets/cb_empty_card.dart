import 'package:hexcolor/hexcolor.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CBEmptyCard extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final double topMargin;

  const CBEmptyCard({
    Key? key,
    this.title,
    this.subTitle,
    this.topMargin = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PSizeConfig.heightSpace(topMargin),
        if (title != null)
          Container(
            margin: EdgeInsets.only(top: PSizeConfig.height(15)),
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: GoogleFonts.workSans(
                color: HexColor('2B2B2B'),
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        if (subTitle != null)
          Container(
            margin: EdgeInsets.only(top: PSizeConfig.height(10)),
            child: Text(
              subTitle!,
              textAlign: TextAlign.center,
              style: GoogleFonts.workSans(
                color: HexColor('2B2B2B'),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          )
      ],
    );
  }
}
