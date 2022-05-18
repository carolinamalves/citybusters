import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:citybusters/widgets/cp_orange_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'siginin/signin_screen.dart';
import 'login/login.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                const Spacer(),
                CBOrangeButton(
                  text: "Login",
                  onTap: () => Get.to(() => LoginPage()),
                ),
                //add btn
                PSizeConfig.heightSpace(120),
                Column(
                  children: [
                    Text(
                      "New around here?",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const SigninPage()),
                            ));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                PSizeConfig.heightSpace(20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
