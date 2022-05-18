import 'package:citybusters/controllers/auth/auth_res.dart';
import 'package:citybusters/controllers/auth/auth_service.dart';
import 'package:citybusters/controllers/auth/auth_state.dart';
import 'package:citybusters/screens/home/home_screen.dart';
import 'package:citybusters/screens/login/login.dart';
import 'package:citybusters/screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthCont extends GetxController {
  final RxBool appSetup = RxBool(false);

  final _authState = AuthState().obs;
  final _lastState = Rx<AuthState>(AuthNull());

  final loading = RxBool(false);
  bool get isAuthLoading => _authState.value == AuthLoading();

  AuthState get state => _authState.value;
  AuthState get prevState => _lastState.value;

  User? get currentUser => FirebaseAuth.instance.currentUser;
  String get userId => currentUser!.uid;

  @override
  void onInit() {
    _authState.listen((AuthState authState) async {
      if (_lastState != authState) _lastState.value = authState;

      if (authState is AuthLoading) {
        loading.value = true;
        return;
      } else {
        loading.value = false;
      }

      if (authState is UnAuth) {
        await FirebaseAuth.instance.signOut();

        if (authState.fromStart) {
          Get.offAll(() => StartPage(), transition: Transition.noTransition);
        } else {
          Get.offAll(() => LoginPage(), transition: Transition.noTransition);
        }
      } else if (authState is Authenticated) {
        Get.offAll(
          () => HomePage(),
          transition: Transition.noTransition,
        );
        return;
      }
    });
    super.onInit();
  }

  @override
  void onReady() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null && !(state is UnAuth)) {
        _decision(AuthResult.LogOut);
      }
    });

    _getAuthenticatedUser();
    super.onReady();
  }

  Future inflateDecision(AuthResult decision) async {
    await _decision(decision);
  }

  // should get from from login cont
  Future LogIn(String email, String password) async {
    _authState.value = AuthLoading();
    final res = await AuthService.localSignIn(email, password);
    await _decision(res);
  }

  // should get from from signup cont
  Future SignUp(String email, String password, String name) async {
    _authState.value = AuthLoading();
    final res = await AuthService.localSignUp(email, password, name);
    await _decision(res);
  }

  Future<void> LogOut() async {
    _authState.value = UnAuth(fromStart: true);
  }

  Future _decision(
    AuthResult res, {
    AuthState? stateOnError,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    switch (res) {
      case AuthResult.SuccessfulSignUp:
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          _decision(AuthResult.Error, stateOnError: stateOnError);
          onError?.call();
        }
        _authState.value = Authenticated(userId: userId);
        onSuccess?.call();
        break;

      case AuthResult.SuccessfulLoginIn:
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          _decision(AuthResult.Error, stateOnError: stateOnError);
          onError?.call();
        } else {
          try {
            await user.getIdTokenResult(true);
            _authState.value = Authenticated(userId: userId);
            onSuccess?.call();
          } on FirebaseAuthException catch (_) {
            await _decision(AuthResult.LogOut);
          } catch (_) {
            await _decision(AuthResult.LogOut);
          }
        }
        break;
      case AuthResult.LogOut:
        await FirebaseAuth.instance.signOut();
        _authState.value = UnAuth(fromStart: true);
        onSuccess?.call();
        break;

      case AuthResult.Error:
        if (stateOnError != null)
          _authState.value = stateOnError;
        else if (_authState.value is AuthLoading)
          _authState.value = _lastState.value;
        onError?.call();
        break;
      default:
    }
  }

  void _getAuthenticatedUser() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await Future.delayed(Duration(milliseconds: 800));
      await _decision(AuthResult.LogOut);
    } else {
      await Future.delayed(Duration(milliseconds: 800));
      await _decision(AuthResult.SuccessfulLoginIn);
    }
  }
}
