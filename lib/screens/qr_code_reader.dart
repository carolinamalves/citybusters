import 'dart:developer';
import 'dart:io';
import 'package:citybusters/widgets/cb_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mobileapp_icons/p_app_icons_icons.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool hasResult = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return CBScaffold(
      fullScreen: true,
      style: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor:
            Platform.isAndroid ? HexColor('121212') : null,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          _buildQrView(context),
          SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: PSizeConfig.height(10),
                horizontal: PSizeConfig.width(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Container(
                      width: PSizeConfig.width(45),
                      height: PSizeConfig.height(45),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Icon(
                          PAppIcons.arrow_left,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = 285.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.orange,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => controller = controller);
    controller.scannedDataStream.listen((scanData) {
      if (hasResult) return;
      setState(() => hasResult = true);

      Get.back(
          result: scanData.code
              ?.replaceAll('https://', '')
              .replaceAll('http://', '')
              .replaceAll('.com', ''));
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
