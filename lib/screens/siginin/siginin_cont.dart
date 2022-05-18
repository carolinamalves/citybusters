import 'package:citybusters/controllers/auth/auth_cont.dart';
import 'package:citybusters/utils/cb_regex.dart';
import 'package:get/get.dart';

class SignInCont extends GetxController {
  final name = RxnString();
  final email = RxnString();
  final password = RxnString();

  final _error = RxnString();
  String get error => _error.value ?? '';

  bool checkName(String _v) => _v.trim().isNotEmpty;
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

    name.listen((_v) {
      if (_error.value != null) _error.value = null;
    });

    email.listen((_v) {
      if (_error.value != null) _error.value = null;
    });

    password.listen((_v) {
      if (_error.value != null) _error.value = null;
    });
  }

  signIn() async {
    // check empty
    if ((name.value?.isEmpty ?? true) ||
        (email.value?.isEmpty == null) ||
        (password.value?.isEmpty == null)) {
      _error.value = 'Dont leave anything behind :)';
      return;
    }

    // check regex
    else if (!checkName(name.value!) ||
        !checkEmail(email.value!) ||
        !checkPassword(password.value!)) {
      _error.value = 'Upss the check the fields again...';
      return;
    }

    await Get.find<AuthCont>()
        .SignUp(email.value!, password.value!, name.value!);
  }
}
