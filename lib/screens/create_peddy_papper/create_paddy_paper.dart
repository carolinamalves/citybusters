import 'package:citybusters/screens/create_peddy_papper/create_paddy_paper_cont.dart';
import 'package:citybusters/widgets/cb_app_bar.dart';
import 'package:citybusters/widgets/cb_empty_card.dart';
import 'package:citybusters/widgets/cb_scaffold.dart';
import 'package:citybusters/widgets/cb_screen_loader.dart';
import 'package:citybusters/widgets/cb_text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mobileapp_icons/p_app_icons_icons.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';

class CreatePaddyPaperScreen extends StatefulWidget {
  const CreatePaddyPaperScreen({Key? key}) : super(key: key);

  @override
  State<CreatePaddyPaperScreen> createState() => _CreatePaddyPaperScreenState();
}

class _CreatePaddyPaperScreenState extends State<CreatePaddyPaperScreen> {
  @override
  Widget build(BuildContext context) {
    return GetX<CreatePaddyPaperCont>(
      init: CreatePaddyPaperCont(),
      builder: (cont) {
        if (cont.loading.isFalse) {}

        return CBLoader(
          show: cont.loading.isFalse,
          indexStack: false,
          body: PageView(
            controller: cont.pageCont,
            children: [
              CBScaffold(
                appBar: CBAppBar(
                  title: 'Create peddy paper',
                  leading: MapEntry(CBAppBarLeading.back, null),
                ),
                body: ListView(
                  children: [
                    PSizeConfig.heightSpace(30),
                    PSizeConfig.hMContainer(
                      child: Text(
                        'Pick your route to start',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: HexColor('2B2B2B').withOpacity(0.8),
                        ),
                      ),
                    ),
                    PSizeConfig.heightSpace(30),
                    if (cont.yourRoutes.isEmpty)
                      CBEmptyCard(
                        title: 'There are no routes',
                        subTitle:
                            'Create your own route to be abble\nto associate a peddy paper.',
                      ),
                    if (cont.yourRoutes.isNotEmpty)
                      ...cont.yourRoutes.map(
                        (_r) => PSizeConfig.hMContainer(
                          child: GestureDetector(
                            onTap: () => cont.onRouteChoose(_r),
                            child: Container(
                              margin: EdgeInsets.only(
                                  bottom: PSizeConfig.height(20)),
                              constraints: BoxConstraints(
                                minHeight: PSizeConfig.height(57),
                                maxWidth: double.maxFinite,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: PSizeConfig.height(8.5),
                                horizontal: PSizeConfig.width(16),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor('F0F0F0'),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _r.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          HexColor('2B2B2B').withOpacity(0.8),
                                    ),
                                  ),
                                  Icon(
                                    PAppIcons.arrow_right2,
                                    color: HexColor('2B2B2B'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    PSizeConfig.heightSpace(PSizeConfig.bottomPadding),
                  ],
                ),
              ),
              CBScaffold(
                appBar: CBAppBar(
                  title: 'Create peddy paper',
                  leading: MapEntry(
                    CBAppBarLeading.back,
                    () => cont.navigate(0),
                  ),
                ),
                floatingActionButton: cont.loading.isTrue
                    ? null
                    : FloatingActionButton(
                        onPressed: () => cont.onCreatePeddyPaper(),
                        backgroundColor: Colors.orange,
                        child: Center(child: Icon(Icons.add)),
                      ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      PSizeConfig.heightSpace(30),
                      PSizeConfig.hMContainer(
                        child: Text(
                          'Fill your peddy paper challenges',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: HexColor('2B2B2B').withOpacity(0.8),
                          ),
                        ),
                      ),
                      PSizeConfig.heightSpace(35),
                      PSizeConfig.hMContainer(
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: PSizeConfig.height(15),
                          ),
                          child: Row(
                            children: [
                              Icon(PAppIcons.location_filled,
                                  color: Colors.orange, size: 20),
                              PSizeConfig.widthSpace(10),
                              Flexible(
                                  child: Text(cont.pickedRoute.value?.places
                                          .first.name ??
                                      ''))
                            ],
                          ),
                        ),
                      ),
                      ...(cont.pickedRoute.value?.places.sublist(1).map(
                                (e) => Column(
                                  key: ObjectKey(e),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PSizeConfig.hMContainer(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          bottom: PSizeConfig.height(15),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(PAppIcons.location_filled,
                                                color: Colors.orange, size: 20),
                                            PSizeConfig.widthSpace(10),
                                            Flexible(child: Text(e.name))
                                          ],
                                        ),
                                      ),
                                    ),
                                    CBTextInput(
                                      key: ValueKey('pass' + e.id),
                                      title: 'Password',
                                      inputAction: TextInputAction.next,
                                      onQuery: (_v) => cont.onPassword(_v, e),
                                    ),
                                    PSizeConfig.heightSpace(20),
                                    CBTextInput(
                                      key: ValueKey('desc' + e.id),
                                      title: 'Description',
                                      maxLines: null,
                                      inputAction: TextInputAction.newline,
                                      onQuery: (_v) =>
                                          cont.onDescription(_v, e),
                                    ),
                                    PSizeConfig.heightSpace(25),
                                  ],
                                ),
                              ) ??
                          []),
                      PSizeConfig.hMContainer(
                        child: Container(
                          child: Text(
                            cont.error,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      PSizeConfig.heightSpace(PSizeConfig.bottomPadding * 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
