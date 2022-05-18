import 'package:citybusters/screens/siginin/siginin_cont.dart';
import 'package:citybusters/widgets/cb_scaffold.dart';
import 'package:citybusters/widgets/cb_screen_loader.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:citybusters/widgets/cb_app_bar.dart';
import 'package:citybusters/widgets/cb_text_input.dart';
import 'package:citybusters/widgets/cp_orange_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SignInCont>(
        init: SignInCont(),
        builder: (cont) {
          return CBScaffold(
            fullScreen: true,
            extendBodyBehindAppBar: true,
            appBar: CBAppBar(
              bgColor: Colors.transparent,
              leading: MapEntry(CBAppBarLeading.back, null),
            ),
            body: CBLoader(
              indexStack: false,
              show: cont.loading.isFalse,
              body: SafeArea(
                top: false,
                child: ListView(
                  children: [
                    PSizeConfig.heightSpace(15),
                    PSizeConfig.hMContainer(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Let's start here",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ),
                    ),
                    PSizeConfig.hMContainer(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Fill in your details to begin . . .',
                          style: GoogleFonts.poppins(
                            color: HexColor("7A7A7A"),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    PSizeConfig.heightSpace(100),
                    CBTextInput(
                      title: "Name",
                      hint: 'Insert your name',
                      inputAction: TextInputAction.done,
                      onQuery: (_v) => cont.name.value = _v,
                    ),
                    PSizeConfig.heightSpace(25),
                    CBTextInput(
                      title: "Email",
                      hint: 'Insert your email',
                      inputAction: TextInputAction.done,
                      onQuery: (_v) => cont.email.value = _v,
                    ),
                    PSizeConfig.heightSpace(25),
                    CBTextInput(
                      title: "Password",
                      hint: 'Insert your password',
                      obscureText: true,
                      inputAction: TextInputAction.done,
                      onQuery: (_v) => cont.password.value = _v,
                    ),
                    PSizeConfig.hMContainer(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          cont.error,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    PSizeConfig.heightSpace(50),
                    Column(
                      children: [
                        CBOrangeButton(text: "Sign Up", onTap: cont.signIn),
                        PSizeConfig.heightSpace(50),
                        Text(
                          "By Signing In, I agree with",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "User Agreement ",
                                  style: GoogleFonts.poppins(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "&",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  " Privacy Policy",
                                  style: GoogleFonts.poppins(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
