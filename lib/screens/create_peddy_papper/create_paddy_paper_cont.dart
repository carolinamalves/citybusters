import 'package:citybusters/controllers/auth/auth_cont.dart';
import 'package:citybusters/models/cb_peddy_paper.dart';
import 'package:citybusters/models/cb_place.dart';
import 'package:citybusters/models/cb_route.dart';
import 'package:citybusters/screens/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart';

class CreatePaddyPaperCont extends GetxController {
  final userId = Get.find<AuthCont>().userId;
  final yourRoutes = RxList<CBRoute>();

  final pickedRoute = Rxn<CBRoute>();

  final passwords = RxMap<String, String?>();
  final descriptions = RxMap<String, String?>();

  late final PageController pageCont;
  final loading = RxBool(true);

  final _error = RxnString();
  String get error => _error.value ?? '';

  @override
  void onInit() {
    pageCont = PageController();
    super.onInit();
  }

  @override
  void onReady() async {
    await fetchYourRoutes();
    super.onReady();
  }

  @override
  void onClose() {
    pageCont.dispose();
    super.onClose();
  }

  onPassword(String pass, CBPlace pl) {
    passwords[pl.id] = pass;
  }

  onDescription(String pass, CBPlace pl) {
    descriptions[pl.id] = pass;
  }

  navigate(int index) {
    _error.value = null;
    pageCont.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  Future fetchYourRoutes() async {
    loading.value = true;

    final res = await FirebaseFirestore.instance
        .collection('routes')
        .where('creatorId', isEqualTo: userId)
        .get();

    yourRoutes.addAll(res.docs.map((e) => CBRoute.fromJson(e.data())));
    loading.value = false;
  }

  onRouteChoose(CBRoute route) async {
    pickedRoute.value = route;

    passwords.clear();
    descriptions.clear();

    route.places.sublist(1).forEach((_p) {
      passwords[_p.id] = null;
      descriptions[_p.id] = null;
    });

    loading.value = true;
    await Future.delayed(Duration(milliseconds: 400));
    loading.value = false;

    navigate(1);
  }

  void onCreatePeddyPaper() async {
    if (passwords.values.toList().any((_r) => _r == null)) {
      _error.value = 'You must specify a password for every step.';
      return;
    }

    if (descriptions.values.toList().any((_r) => _r == null)) {
      _error.value = 'You must specify a description for every step.';
      return;
    }

    loading.value = true;

    // create peddy paper
    final paddyId = nanoid();

    final peddy = CBPeddyPaper(
      id: paddyId,
      passwords: passwords.map((key, value) => MapEntry(key, value!)),
      descriptions: descriptions.map((key, value) => MapEntry(key, value!)),
      route: pickedRoute.value!,
    );

    final batch = FirebaseFirestore.instance.batch();

    batch.set(FirebaseFirestore.instance.collection('paddys').doc(paddyId),
        peddy.toJson());

    batch.delete(FirebaseFirestore.instance
        .collection('routes')
        .doc(pickedRoute.value!.id));

    await batch.commit();

    loading.value = false;
    Get.offAll(() => HomePage());
  }
}
