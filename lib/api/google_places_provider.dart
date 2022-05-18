import 'dart:io';
import 'package:citybusters/utils.dart';
import 'package:get/get_connect.dart';
import 'package:mobileapp_models/models/party_address_model.dart';
import 'package:mobileapp_models/models/party_coordinate_model.dart';
import 'package:mobileapp_models/new_models/search/pm_place_details.dart';
import 'package:uuid/uuid.dart';

class GooglePlacesAPIEndpoint {
  static String apiKey = Platform.isAndroid
      ? ApiKeysManager.androidGooglePlacesApiKey
      : ApiKeysManager.iosGooglePlacesApiKey;

  static String placesApiBase = 'https://maps.googleapis.com/maps/api/place';

  static String getAutocompleteSuggestions(
    String query,
    String sessionToken, {
    String country = 'pt',
  }) =>
      '/autocomplete/json?input=$query&location=38.736946,-9.142685&radius=10000&language=pt&components=country:$country&key=$apiKey&sessiontoken=$sessionToken';

  static String getPlaceDetails(
    String placeId,
    String sessionToken,
  ) =>
      '/details/json?place_id=$placeId&fields=name,vicinity,geometry&language=pt&key=$apiKey&sessiontoken=$sessionToken';
}

class GooglePlacesAPI extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = GooglePlacesAPIEndpoint.placesApiBase;
  }

  PMPlaceDetails _parseSearchedPlace(Map<String, dynamic> place) {
    final info = place['description'].toString().split(', ');
    final title = info.first;
    info.removeAt(0);
    final description = info.join(', ');

    return PMPlaceDetails(
      id: place['place_id'],
      title: title,
      description: description,
    );
  }

  PAddress _parsePlaceDetails(Map<String, dynamic> data, String placeId) {
    // filed: name
    String name = data['result']['name'];

    // field: vicinity
    String vicinity = data['result']['vicinity'];

    // field: geometry (lat, lng)
    final geometry =
        data['result']['geometry']['location'] as Map<String, dynamic>;

    final address = PAddress(
      name: name,
      vicinity: vicinity,
      placeId: placeId,
      coordinate: PCoordinate(lat: geometry['lat'], lng: geometry['lng']),
    );

    return address;
  }

  Future<List<PMPlaceDetails>> getAutocompleteSuggestions(
    String query,
  ) async {
    final sessionToken = Uuid().v4();
    final response = await get(
      GooglePlacesAPIEndpoint.getAutocompleteSuggestions(
        query,
        sessionToken,
      ),
    );

    try {
      if (response.statusCode == 200) {
        final result = response.body;
        if (result['status'] == 'OK') {
          return result['predictions']
              .map<PMPlaceDetails>((p) => _parseSearchedPlace(p))
              .toList();
        }
      }
      return [];
    } catch (error) {
      return [];
    }
  }

  Future<PAddress?> getPlaceDetails(String placeId) async {
    var sessionToken = Uuid().v4();

    final response = await get(
      GooglePlacesAPIEndpoint.getPlaceDetails(placeId, sessionToken),
    );

    try {
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        return _parsePlaceDetails(response.body, placeId);
      }
    } catch (_) {}
    return null;
  }
}
