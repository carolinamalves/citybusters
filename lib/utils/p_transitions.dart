import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PTransitions {
  static void Function() fadeOffAll(Widget Function() screen,
          {Transition? transition}) =>
      () => Get.offAll(
            screen,
            gestureWidth: (context) => 15,
            transition: transition ??
                (Platform.isAndroid ? Transition.native : Transition.fadeIn),
            duration: Platform.isAndroid
                ? Duration(milliseconds: 50)
                : Duration(milliseconds: 250),
          );

  static Future<T?>? Function() fade<T>(Widget Function() screen) => () =>
      Get.to<T>(
        screen,
        popGesture: false,
        transition: Platform.isAndroid ? Transition.native : Transition.fadeIn,
        duration: Platform.isAndroid
            ? Duration(milliseconds: 50)
            : Duration(milliseconds: 100),
      );

  static Future<T?>? Function() noTransition<T>(Widget Function() screen) =>
      () => Get.to<T>(
            screen,
            popGesture: false,
            transition: Platform.isAndroid
                ? Transition.native
                : Transition.noTransition,
            duration: Platform.isAndroid
                ? Duration(milliseconds: 50)
                : Duration(milliseconds: 50),
          );

  static Future<T?>? Function() normal<T>(Widget Function() screen,
          {String? routeName}) =>
      () => Get.to<T>(
            screen,
            popGesture: true,
            gestureWidth: (context) => 15,
            routeName: routeName,
            duration: Platform.isAndroid
                ? Duration(milliseconds: 50)
                : Duration(milliseconds: 300),
            transition: Platform.isAndroid ? Transition.native : null,
          );

  static Future<T?>? Function() normalOff<T>(Widget Function() screen) =>
      () => Get.off<T>(
            screen,
            popGesture: true,
            gestureWidth: (context) => 15,
            duration: Platform.isAndroid
                ? Duration(milliseconds: 50)
                : Duration(milliseconds: 300),
            transition: Platform.isAndroid ? Transition.native : null,
          );
}
