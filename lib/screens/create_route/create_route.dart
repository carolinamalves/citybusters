import 'dart:io';
import 'package:citybusters/screens/create_route/create_route_cont.dart';
import 'package:citybusters/widgets/cb_scaffold.dart';
import 'package:citybusters/widgets/cb_screen_loader.dart';
import 'package:citybusters/widgets/cb_text_input.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:citybusters/widgets/cb_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mobileapp_icons/p_app_icons_icons.dart';
import 'package:mobileapp_icons_dep/party_icons.dart';
import 'package:mobileapp_utils/utils/party_measure_size.dart';

class CreateRoute extends StatefulWidget {
  const CreateRoute({Key? key}) : super(key: key);

  @override
  State<CreateRoute> createState() => _CreateRouteState();
}

class _CreateRouteState extends State<CreateRoute> {
  double height = 0;

  List<Widget> _buildDot(double height) {
    return List.generate(
      (height / 15).ceil(),
      (index) => Container(
        margin: const EdgeInsets.only(bottom: 11),
        child: PIcons.dot(
          color: Colors.orange,
          width: PSizeConfig.width(3),
          height: PSizeConfig.height(3),
        ),
      ),
    );
  }

  Widget _buildPlaceElem({
    String? text,
    String? hint,
    VoidCallback? onTap,
    VoidCallback? onRemove,
    bool isAdd = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: PSizeConfig.height(40),
        width: PSizeConfig.width(300),
        padding: EdgeInsets.only(
          left: PSizeConfig.height(16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: HexColor('F0F0F0'),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  text ?? hint ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: HexColor('2B2B2B'),
                  ),
                ),
              ),
              if (text != null)
                GestureDetector(
                  onTap: () {
                    if (Platform.isIOS) HapticFeedback.lightImpact();
                    onRemove?.call();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(isAdd ? Icons.add : PAppIcons.close),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage({
    XFile? file,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return PSizeConfig.hMContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: PSizeConfig.width(180),
                height: PSizeConfig.height(125),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor('F0F0F0'),
                  image: file == null
                      ? null
                      : DecorationImage(
                          image: Image.asset(file.path).image,
                          fit: BoxFit.cover,
                        ),
                ),
                child: file == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            PAppIcons.gallery,
                            size: 30,
                            color: HexColor('2B2B2B').withOpacity(0.7),
                          ),
                          PSizeConfig.heightSpace(5),
                          Text(
                            'Add Image',
                            style: GoogleFonts.poppins(
                              color: HexColor('2B2B2B'),
                            ),
                          )
                        ],
                      )
                    : Container(),
              ),
            ),
          ),
          if (file != null) PSizeConfig.widthSpace(20),
          if (file != null)
            GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: HexColor('2B2B2B').withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      PAppIcons.trash_full,
                      size: 22,
                      color: HexColor('2B2B2B'),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX<CreateRouteCont>(
      init: CreateRouteCont(),
      builder: (cont) {
        return CBLoader(
          show: cont.loading.isFalse,
          indexStack: false,
          body: CBScaffold(
            resizeToAvoidBottomInset: false,
            appBar: CBAppBar(
              title: 'Create your own Route',
              leading: MapEntry(CBAppBarLeading.back, null),
            ),
            floatingActionButton: cont.loading.isTrue
                ? null
                : FloatingActionButton(
                    onPressed: cont.createRoute,
                    backgroundColor: Colors.orange,
                    child: Center(child: Icon(Icons.add)),
                  ),
            body: ListView(
              children: [
                PSizeConfig.heightSpace(30),
                _buildImage(
                  onTap: cont.onImageTap,
                  onDelete: cont.onImageDeleteTap,
                  file: cont.image.value,
                ),
                PSizeConfig.heightSpace(30),
                CBTextInput(
                  hint: "Name your route",
                  onQuery: cont.onName,
                  inputAction: TextInputAction.next,
                ),
                PSizeConfig.heightSpace(20),
                CBTextInput(
                  hint: "Give some descritpion",
                  onQuery: cont.onDescription,
                  inputAction: TextInputAction.done,
                ),
                PSizeConfig.heightSpace(30),
                PSizeConfig.hMContainer(
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: PSizeConfig.height(40),
                              child: Icon(
                                PAppIcons.location_filled,
                                color: Colors.orange,
                              ),
                            ),
                            Expanded(
                                child: Column(children: _buildDot(height))),
                            Icon(
                              PAppIcons.location_filled,
                              color: Colors.orange,
                            ),
                            PSizeConfig.heightSpace(30),
                          ],
                        ),
                        PSizeConfig.widthSpace(10),
                        Align(
                          alignment: Alignment.topCenter,
                          child: PMeasureSize(
                            onChange: (size) {
                              if (size?.height != null) {
                                setState(() {
                                  height = size!.height -
                                      2 * PSizeConfig.toRealHeight(40);
                                });
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: PSizeConfig.height(20)),
                                  child: _buildPlaceElem(
                                    text: cont.startPlace.value?.name,
                                    hint: 'Add a place to start',
                                    onTap: () => cont.addPlacePoint(-1),
                                    onRemove: () => cont.onPlacePointRemove(
                                        cont.startPlace.value),
                                  ),
                                ),
                                ...cont.waypoints
                                    .map(
                                      (_w) => Container(
                                        margin: EdgeInsets.only(
                                            bottom: PSizeConfig.height(20)),
                                        child: _buildPlaceElem(
                                          text: _w.name,
                                          onRemove: () =>
                                              cont.onPlacePointRemove(_w),
                                          onTap: () => cont.addPlacePoint(null,
                                              place: _w),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: PSizeConfig.height(20)),
                                  child: _buildPlaceElem(
                                    text: 'Add a new waypoint',
                                    isAdd: true,
                                    onTap: () => cont.addPlacePoint(null),
                                  ),
                                ),
                                _buildPlaceElem(
                                  text: cont.endPlace.value?.name,
                                  hint: 'Add a place to finish',
                                  onTap: () => cont.addPlacePoint(-2),
                                  onRemove: () => cont
                                      .onPlacePointRemove(cont.endPlace.value),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PSizeConfig.hMContainer(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
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
                PSizeConfig.heightSpace(PSizeConfig.bottomPadding)
              ],
            ),
          ),
        );
      },
    );
  }
}
