import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefCont extends GetxController {
  final SharedPreferences _sharedPref;

  SharedPrefCont(this._sharedPref);

  SharedPreferences get pref => _sharedPref;
}
