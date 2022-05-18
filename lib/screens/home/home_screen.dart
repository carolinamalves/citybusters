import 'package:cached_network_image/cached_network_image.dart';
import 'package:citybusters/models/cb_route.dart';
import 'package:citybusters/screens/create_route/create_route.dart';
import 'package:citybusters/screens/home/home_cont.dart';
import 'package:citybusters/screens/route_poster/route_poster.dart';
import 'package:citybusters/screens/settings_screen.dart';
import 'package:citybusters/widgets/cb_scaffold.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:citybusters/widgets/cb_icon_button.dart';
import 'package:citybusters/widgets/cb_text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mobileapp_icons/p_app_icons_icons.dart';
import 'package:nanoid/nanoid.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _sectionTitle(String text) {
    return PSizeConfig.hMContainer(
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          /*Text(
            "View all",
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),*/
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  CBRoute get fakeRout => CBRoute(
        id: 'routeid',
        name: "Best Route",
        coverUrl: 'https://picsum.photos/200/300',
        creatorId: "creatorId",
        places: [],
        description: "Amazing route",
      );

  @override
  Widget build(BuildContext context) {
    return GetX<HomeCont>(
      init: HomeCont(),
      builder: (cont) {
        final peddys = cont.peddys;
        final topRoutes = cont.topRoutes;
        final myRoutes = cont.myRoutes;

        return CBScaffold(
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SafeArea(
              bottom: false,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  PSizeConfig.heightSpace(30),
                  Container(
                    margin: EdgeInsets.only(
                      left: PSizeConfig.hMargin / 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Home",
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Explore this City!",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                color: HexColor("A1A1A1"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(() => CreateRoute()),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "+  Create your Route",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: PSizeConfig.width(10),
                                  vertical: PSizeConfig.height(7.5),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                            CBIconButton(
                              onTap: () => Get.to(() => SettingsPage()),
                              icon: PAppIcons.menu_dot_vertical,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PSizeConfig.heightSpace(20),
                  CBTextInput(
                    hint: 'Search anything . . .',
                    inputAction: TextInputAction.done,
                  ),
                  PSizeConfig.heightSpace(10),
                  ...topRoutes.isEmpty
                      ? []
                      : [
                          PSizeConfig.heightSpace(20),
                          _sectionTitle('Top Routes'),
                          PSizeConfig.heightSpace(15),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                PSizeConfig.widthSpace(PSizeConfig.hMargin / 2),
                                ...topRoutes.map(
                                  (_r) => Container(
                                    margin: EdgeInsets.only(
                                      right: PSizeConfig.hMargin / 2,
                                    ),
                                    child: CBRouteCard(
                                      _r,
                                      onTap: () => Get.to(
                                        () => RoutePosterPage(routeId: _r.id),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                  ...peddys.isEmpty
                      ? []
                      : [
                          PSizeConfig.heightSpace(20),
                          _sectionTitle('Peddy Papers'),
                          PSizeConfig.heightSpace(15),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                PSizeConfig.widthSpace(PSizeConfig.hMargin / 2),
                                ...peddys.map(
                                  (_r) => Container(
                                    margin: EdgeInsets.only(
                                      right: PSizeConfig.hMargin / 2,
                                    ),
                                    child: CBRouteCard(
                                      _r.route,
                                      onTap: () => Get.to(
                                        () => RoutePosterPage(peddyId: _r.id),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                  ...myRoutes.isEmpty
                      ? []
                      : [
                          PSizeConfig.heightSpace(20),
                          _sectionTitle('My Routes'),
                          PSizeConfig.heightSpace(15),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                PSizeConfig.widthSpace(PSizeConfig.hMargin / 2),
                                ...myRoutes.map(
                                  (_r) => Container(
                                    margin: EdgeInsets.only(
                                      right: PSizeConfig.hMargin / 2,
                                    ),
                                    child: CBRouteCard(
                                      _r,
                                      onTap: () => Get.to(
                                        () => RoutePosterPage(routeId: _r.id),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                  PSizeConfig.heightSpace(PSizeConfig.bottomPadding)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

//single child scroll view

class CBRouteCard extends StatelessWidget {
  final CBRoute route;
  final VoidCallback? onTap;

  const CBRouteCard(
    this.route, {
    Key? key,
    this.onTap,
  }) : super(key: key);

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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          route.coverUrl != null
              ? CachedNetworkImage(
                  cacheKey: nanoid(),
                  imageUrl: route.coverUrl!,
                  imageBuilder: (ctx, im) => image(im),
                  placeholder: (_, __) => _imagePlaceholder(),
                )
              : _imagePlaceholder(),
          PSizeConfig.heightSpace(10),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: PSizeConfig.width(5),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.name,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: HexColor('2B2B2B'),
                      ),
                    ),
                    /* Row(
                      children: [
                        Icon(
                          PAppIcons.location_filled,
                          size: 13,
                          color: HexColor('A1A1A1'),
                        ),
                        PSizeConfig.widthSpace(3),
                        Text(
                          'Sumol ad',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: HexColor('A1A1A1'),
                          ),
                        )
                      ],
                    ),*/
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
