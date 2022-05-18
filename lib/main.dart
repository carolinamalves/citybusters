import 'package:citybusters/controllers/auth/auth_cont.dart';
import 'package:citybusters/firebase_options.dart';
import 'package:citybusters/screens/splash_screen.dart';
import 'package:citybusters/services/init_service.dart';
import 'package:citybusters/services/p_utils.dart';
import 'package:citybusters/services/shared_pref_cont.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;

  await InitService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final sharedPref = await SharedPreferences.getInstance();
  Get.put<SharedPrefCont>(SharedPrefCont(sharedPref), permanent: true);

  Get.put(AuthCont(), permanent: true);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(SetupApp()),
  );
}

class SetupApp extends StatelessWidget {
  const SetupApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: QlClient,
      child: GetMaterialApp(
        title: 'CityBusters',
        debugShowCheckedModeBanner: false,
        enableLog: true,
        themeMode: ThemeMode.light,
        builder: (context, child) {
          assert(debugCheckHasMediaQuery(context));
          PSizeConfig().init(context);

          return ScrollConfiguration(
            behavior: PSplashScrollHider(),
            child: child!,
          );
        },
        home: SplashScreen(),
      ),
    );
  }
}
