import 'package:citybusters/screens/login/login_cont.dart';
import 'package:citybusters/widgets/cb_app_bar.dart';
import 'package:citybusters/widgets/cb_scaffold.dart';
import 'package:citybusters/widgets/cb_screen_loader.dart';
import 'package:citybusters/widgets/cb_text_input.dart';
import 'package:citybusters/widgets/cp_orange_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<LogInCont>(
      init: LogInCont(),
      builder: (cont) {
        return CBScaffold(
          fullScreen: true,
          extendBodyBehindAppBar: true,
          appBar: CBAppBar(
            bgColor: Colors.transparent,
            leading: Navigator.of(context).canPop()
                ? MapEntry(CBAppBarLeading.back, null)
                : null,
          ),
          body: CBLoader(
            indexStack: false,
            show: cont.loading.isFalse,
            body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Container(
                    height: PSizeConfig.height(300),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image: AssetImage("assets/images/logo_black.png"),
                      ),
                    ),
                  ),
                  PSizeConfig.heightSpace(30),
                  CBTextInput(
                    title: "Email",
                    hint: 'Insert your email',
                    inputAction: TextInputAction.next,
                    onQuery: (_v) => cont.email.value = _v,
                  ),
                  PSizeConfig.heightSpace(25),
                  CBTextInput(
                    title: "Password",
                    hint: 'Insert your password',
                    inputAction: TextInputAction.done,
                    obscureText: true,
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
                  PSizeConfig.heightSpace(45),
                  Column(
                    children: [
                      CBOrangeButton(text: "Login", onTap: cont.logIn),
                      PSizeConfig.heightSpace(25),
                      Container(
                        child: Text(
                          "If you are encountering any troubles, please ",
                          style: GoogleFonts.poppins(
                            color: HexColor('2B2B2B'),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      GestureDetector(
                        //go to mail
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "click here!",
                            style: GoogleFonts.poppins(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
