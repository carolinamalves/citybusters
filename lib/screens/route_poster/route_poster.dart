import 'package:cached_network_image/cached_network_image.dart';
import 'package:citybusters/models/cb_coordinate.dart';
import 'package:citybusters/models/cb_peddy_paper.dart';
import 'package:citybusters/models/cb_place.dart';
import 'package:citybusters/models/cb_route.dart';
import 'package:citybusters/screens/map_screen.dart';
import 'package:citybusters/screens/qr_code_reader.dart';
import 'package:citybusters/widgets/cb_dialog.dart';
import 'package:citybusters/widgets/cb_scaffold.dart';
import 'package:citybusters/widgets/cb_screen_loader.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mobileapp_components/dialogs/party_dialog.dart';
import 'package:mobileapp_components/text_inputs/party_expandable_text_field.dart';
import 'package:mobileapp_icons/p_app_icons_icons.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoutePosterPage extends StatelessWidget {
  final String? routeId;
  final String? peddyId;

  const RoutePosterPage({
    Key? key,
    this.routeId,
    this.peddyId,
  })  : assert(routeId != null || peddyId != null),
        super(key: key);

  Widget _imagePlaceholder() => Container(
        width: PSizeConfig.width(180),
        height: PSizeConfig.height(125),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: HexColor('F0F0F0'),
        ),
      );

  Widget image(ImageProvider _i) => Container(
        width: PSizeConfig.width(180),
        height: PSizeConfig.height(125),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: _i,
            fit: BoxFit.cover,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GetX<RoutePosterCont>(
      init: RoutePosterCont(
        routeId: routeId,
        peddyId: peddyId,
      ),
      builder: (cont) {
        if (cont.loading.isTrue) {}

        return CBLoader(
          show: cont.loading.isFalse,
          body: cont.loading.isTrue || cont.isReady.isFalse
              ? Container()
              : CBScaffold(
                  fullScreen: true,
                  extendBodyBehindAppBar: true,
                  backgroundColor: Colors.white,
                  body: Stack(
                    children: [
                      SizedBox.expand(
                        child: MapView(
                          prefCoord: cont.isRoute ? null : cont.unlockedCoord,
                          places: cont.isRoute ? cont.route.places : null,
                          zoom: cont.isRoute ? 14 : 17,
                          initPos: cont.isRoute
                              ? LatLng(cont.route.places.first.coordinate.lat,
                                  cont.route.places.first.coordinate.lng)
                              : LatLng(cont.unlockedCoord.first.lat,
                                  cont.unlockedCoord.first.lng),
                        ),
                      ),
                      SafeArea(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: PSizeConfig.width(15)),
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
                              if (!cont.isRoute)
                                GestureDetector(
                                  onTap: cont.unLockNext,
                                  child: Container(
                                    width: PSizeConfig.width(45),
                                    height: PSizeConfig.height(45),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange.withOpacity(0.5),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        PAppIcons.camera,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      ConfettiWidget(
                        confettiController: cont.confettiCont,
                        blastDirectionality: BlastDirectionality.explosive,
                        particleDrag: 0.05,
                        emissionFrequency: 0.05,
                        numberOfParticles: 30,
                        gravity: 0.05,
                        shouldLoop: false,
                        colors: const [
                          Colors.green,
                          Colors.blue,
                          Colors.pink,
                          Colors.orange,
                          Colors.purple
                        ],
                      ),
                      SafeArea(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            constraints: BoxConstraints(
                                maxHeight: PSizeConfig.blockHeight * 60),
                            margin: EdgeInsets.only(
                              left: PSizeConfig.width(15),
                              right: PSizeConfig.width(15),
                              top: PSizeConfig.height(10),
                            ),
                            padding: EdgeInsets.only(
                              left: PSizeConfig.width(20),
                              right: PSizeConfig.width(5),
                              top: PSizeConfig.height(20),
                              bottom: PSizeConfig.height(15),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    spreadRadius: 10,
                                  )
                                ]),
                            child: CupertinoScrollbar(
                              controller: cont.scrollCont,
                              child: Container(
                                padding: EdgeInsets.only(
                                  right: PSizeConfig.width(15),
                                ),
                                child: ListView(
                                  controller: cont.scrollCont,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  children: [
                                    Text(
                                      cont.isRoute
                                          ? cont.route.name
                                          : cont.peddy.route.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    PSizeConfig.heightSpace(15),
                                    Row(
                                      children: [
                                        (cont.isRoute
                                                ? cont.route.coverUrl != null
                                                : cont.peddy.route.coverUrl !=
                                                    null)
                                            ? CachedNetworkImage(
                                                imageUrl: cont.isRoute
                                                    ? cont.route.coverUrl!
                                                    : cont
                                                        .peddy.route.coverUrl!,
                                                imageBuilder: (ctx, im) =>
                                                    image(im),
                                                placeholder: (_, __) =>
                                                    _imagePlaceholder(),
                                              )
                                            : _imagePlaceholder(),
                                      ],
                                    ),
                                    ...(cont.isRoute
                                        ? []
                                        : [
                                            PSizeConfig.heightSpace(15),
                                            Text(
                                              "Hint",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: HexColor('2B2B2B'),
                                              ),
                                            ),
                                            PExpandableTextField(
                                              text: cont.unlockedPlaces
                                                          .length ==
                                                      cont.peddy.route.places
                                                          .length
                                                  ? (cont.peddy.descriptions[
                                                          cont.peddy.route
                                                              .places[cont.unlockedPlaces.length - 1].id]
                                                      as String)
                                                  : (cont.peddy.descriptions[cont
                                                      .peddy
                                                      .route
                                                      .places[cont.unlockedPlaces.length]
                                                      .id] as String),
                                              maxLines: 4,
                                              collapseText: 'Read less',
                                              extendText: 'Read more',
                                              textMargin: 0,
                                              textStyle: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: HexColor('2B2B2B'),
                                              ),
                                              extendCollapseTextStyle:
                                                  GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.orange,
                                              ),
                                            )
                                          ]),
                                    PSizeConfig.heightSpace(15),
                                    Text(
                                      "Description",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: HexColor('2B2B2B'),
                                      ),
                                    ),
                                    PExpandableTextField(
                                      text: (cont.isRoute
                                              ? cont.route.description
                                              : cont.peddy.route.description) ??
                                          '',
                                      maxLines: cont.isRoute ? 4 : 2,
                                      collapseText: 'Read less',
                                      extendText: 'Read more',
                                      textMargin: 0,
                                      textStyle: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: HexColor('2B2B2B'),
                                      ),
                                      extendCollapseTextStyle:
                                          GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class RoutePosterCont extends GetxController {
  RoutePosterCont({this.routeId, this.peddyId});

  final scrollCont = ScrollController();
  final confettiCont = ConfettiController(
    duration: Duration(seconds: 5),
  );

  final String? routeId;
  final String? peddyId;

  final _route = Rxn<CBRoute>();
  CBRoute get route => _route.value!;

  final _peddy = Rxn<CBPeddyPaper>();
  CBPeddyPaper get peddy => _peddy.value!;
  final unlockedPlaces = RxList<CBPlace>();
  final unlockedCoord = RxList<CBCoordinate>();

  final isReady = RxBool(false);
  final loading = RxBool(false);
  bool get isRoute => routeId != null;

  @override
  void onInit() {
    unlockedPlaces.listen((p0) {
      unlockedCoord.clear();
      unlockedCoord.addAll(p0.map((e) => e.coordinate));

      if (p0.length == peddy.route.places.length) {
        print('play confetti...');
        Future.delayed(Duration(milliseconds: 100), () {
          if (!isClosed) confettiCont.play();
        });
      }
    });

    if (isRoute) {
      _route.listen((_v) {
        if (_v == null) {
          isReady.value = false;
        } else {
          isReady.value = true;
        }
      });
    } else {
      _peddy.listen((_v) {
        if (_v == null) {
          isReady.value = false;
        } else {
          isReady.value = true;
        }
      });
    }
    super.onInit();
  }

  void unLockNext() async {
    if (_peddy.value == null ||
        unlockedPlaces.length == _peddy.value?.route.places.length) return;

    final res = await Get.to(() => QRViewExample());
    if (peddy.passwords[peddy.route.places[unlockedPlaces.length].id] == res) {
      unlockedPlaces.add(_peddy.value!.route.places[unlockedPlaces.length]);
      if (unlockedPlaces.length == peddy.route.places.length) return;
      await Get.dialog(
          CBDialog(title: "Good job!\nYou're moving to the next step!"));
    } else {
      await Get.dialog(
          CBDialog(title: "Ups...\nLooks like that's not a valid QR Code!"));
    }
  }

  @override
  void onReady() async {
    await fetch();
    super.onReady();
  }

  Future fetch() async {
    loading.value = true;

    if (isRoute) {
      final res = await FirebaseFirestore.instance
          .collection('routes')
          .doc(routeId)
          .get();
      if (!res.exists || res.data() == null) {
        // say something
        loading.value = false;
        return;
      }
      _route.value = CBRoute.fromJson(res.data()!);
    } else {
      final res = await FirebaseFirestore.instance
          .collection('paddys')
          .doc(peddyId)
          .get();
      if (!res.exists || res.data() == null) {
        // say something
        loading.value = false;
        return;
      }
      _peddy.value = CBPeddyPaper.fromJson(res.data()!);
      unlockedPlaces.add(_peddy.value!.route.places.first);
    }

    loading.value = false;
  }

  @override
  void onClose() {
    confettiCont.stop();
    scrollCont.dispose();
    confettiCont.dispose();
    super.onClose();
  }
}
