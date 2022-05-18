import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  "assets/images/bg_start_page.png",
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  HexColor("202020").withOpacity(0.1),
                  HexColor("202020"),
                  HexColor("202020"),
                ],
                stops: [0, 0.67, 0.7],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                PSizeConfig.heightSpace(200),
                Container(
                  height: PSizeConfig.height(292),
                  width: PSizeConfig.width(375),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.center,
                      image: AssetImage(
                        "assets/images/logo_white.png",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
