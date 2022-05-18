import 'package:citybusters/controllers/auth/auth_cont.dart';
import 'package:citybusters/models/cb_peddy_paper.dart';
import 'package:citybusters/models/cb_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeCont extends GetxController {
  final userId = Get.find<AuthCont>().userId;

  final topRoutes = RxList<CBRoute>();
  final myRoutes = RxList<CBRoute>();
  final peddys = RxList<CBPeddyPaper>();

  @override
  void onInit() {
    super.onInit();

    FirebaseFirestore.instance.collection('paddys').snapshots().listen(
      (_v) {
        peddys.clear();
        peddys.addAll(_v.docs.map((_r) => CBPeddyPaper.fromJson(_r.data())));
      },
    );

    FirebaseFirestore.instance
        .collection('routes')
        .where('creatorId', isNotEqualTo: userId)
        .snapshots()
        .listen(
      (_v) {
        topRoutes.clear();
        topRoutes.addAll(_v.docs.map((_r) => CBRoute.fromJson(_r.data())));
      },
    );

    FirebaseFirestore.instance
        .collection('routes')
        .where('creatorId', isEqualTo: userId)
        .snapshots()
        .listen(
      (_v) {
        myRoutes.clear();
        myRoutes.addAll(_v.docs.map((_r) => CBRoute.fromJson(_r.data())));
      },
    );
  }
}
