import 'package:citybusters/models/cb_coordinate.dart';
import 'package:citybusters/models/cb_model.dart';

class CBPlace extends CBModel {
  final String id;
  final String name;
  final CBCoordinate coordinate;

  CBPlace({
    required this.id,
    required this.name,
    required this.coordinate,
  });

  factory CBPlace.fromJson(Map<String, dynamic> json) {
    return CBPlace(
      id: json['id'],
      name: json['name'],
      coordinate: CBCoordinate.fromJson(json['coordinate']),
    );
  }

  @override
  Map<String, dynamic> toJson({bool withId = true}) {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['coordinate'] = coordinate.toJson();
    return data;
  }
}
