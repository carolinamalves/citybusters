import 'package:citybusters/api/google_places_provider.dart';
import 'package:citybusters/models/cb_coordinate.dart';
import 'package:citybusters/models/cb_place.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobileapp_models/new_models/search/pm_place_details.dart';
import 'package:mobileapp_utils/party_utils.dart';

class SearchPlaceCont extends GetxController {
  final query = RxString('');
  final placesResults = RxList<PMPlaceDetails>();

  final placesApi = Get.put<GooglePlacesAPI>(GooglePlacesAPI());
  final loading = RxBool(false);

  @override
  void onInit() {
    query.listen(searchPlace);
    super.onInit();
  }

  @override
  void onClose() {
    placesApi.dispose();
    super.onClose();
  }

  Future searchPlace(String _q) async {
    if (_q.trim().isEmpty) {
      placesResults.clear();
      return;
    }

    final res = await placesApi.getAutocompleteSuggestions(_q.trim());

    print(res);

    placesResults.clear();
    placesResults.addAll(res);
  }

  Future onPlaceTap(PMPlaceDetails place) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(Duration(milliseconds: 300));

    final placeAddress = await PUtils.smoothTimer(
      placesApi.getPlaceDetails(place.id),
      onStart: () => loading.value = true,
      onEnd: () => loading.value = false,
    );

    if (placeAddress == null) {
      return;
    }

    await Future.delayed(Duration(milliseconds: 100));
    Get.back(
      result: CBPlace(
        id: placeAddress.placeId,
        name: placeAddress.name,
        coordinate: CBCoordinate(
          lat: placeAddress.coordinate.lat,
          lng: placeAddress.coordinate.lng,
        ),
      ),
    );
  }
}
