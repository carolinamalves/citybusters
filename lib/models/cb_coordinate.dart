import 'package:citybusters/models/cb_model.dart';

class CBCoordinate extends CBModel {
  final double lat;
  final double lng;

  CBCoordinate({
    required this.lat,
    required this.lng,
  });

  factory CBCoordinate.fromJson(Map<String, dynamic> json) {
    return CBCoordinate(lat: json['lat'], lng: json['lng']);
  }

  @override
  Map<String, dynamic> toJson({bool withId = true}) {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
