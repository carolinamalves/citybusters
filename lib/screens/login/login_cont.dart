import 'package:citybusters/controllers/auth/auth_cont.dart';
import 'package:citybusters/utils/cb_regex.dart';
import 'package:get/get.dart';

class LogInCont extends GetxController {
  final email = RxnString();
  final password = RxnString();

  final _error = RxnString();
  String get error => _error.value ?? '';

  bool checkEmail(String _v) => CBRegex.email.hasMatch(_v);
  bool checkPassword(String _v) => CBRegex.password.hasMatch(_v);

  final loading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loading.bindStream(Get.find<AuthCont>().loading.stream);
    loading.listen((_v) {
      if (_error.value != null) _error.value = null;
    });

    email.listen((_v) {
      if (_error.value != null) _error.value = null;
    });

    password.listen((_v) {
      if (_error.value != null) _error.value = null;
    });
  }

  logIn() async {
    // check empty
    if ((email.value?.isEmpty ?? true) || (password.value?.isEmpty == null)) {
      _error.value = 'You must fill fill all spots to continue';
      return;
    }
    // check regex
    else if (!checkEmail(email.value!) || !checkPassword(password.value!)) {
      _error.value = 'Your fields must ...';
      return;
    }

    await Get.find<AuthCont>().LogIn(email.value!, password.value!);
  }
}
