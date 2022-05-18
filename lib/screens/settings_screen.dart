import 'package:citybusters/controllers/auth/auth_cont.dart';
import 'package:citybusters/screens/create_peddy_papper/create_paddy_paper.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:citybusters/widgets/cb_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mobileapp_components/reactive_ui/various/p_rx_switch.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);
  final notificationSwitch = RxBool(true);

  Widget _buildButton(
    String text, {
    Color? color,
    VoidCallback? onTap,
    Widget? action,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minHeight: PSizeConfig.height(50),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: PSizeConfig.width(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: color ?? HexColor('2B2B2B'),
              ),
            ),
            if (action != null) action,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CBAppBar(
        leading: MapEntry(CBAppBarLeading.back, null),
        title: 'More features',
      ),
      body: SafeArea(
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            PSizeConfig.heightSpace(20),
            _buildButton(
              'Notifications',
              action: PRxSwitch(cont: notificationSwitch),
            ),
            _buildButton('Buy Tickets'),
            _buildButton('Account'),
            _buildButton(
              'Create Peddy',
              onTap: () => Get.to(() => CreatePaddyPaperScreen()),
            ),
            _buildButton('Help & Support'),
            _buildButton(
              'Log out',
              color: Colors.red,
              onTap: Get.find<AuthCont>().LogOut,
            ),
          ],
        ),
      ),
    );
  }
}
