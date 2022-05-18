import 'package:citybusters/models/cb_model.dart';
import 'package:citybusters/models/cb_place.dart';

class CBRoute extends CBModel {
  final String id;
  final String name;
  final String? coverUrl;
  final String creatorId;
  final List<CBPlace> places;
  final String? description;

  CBRoute({
    required this.id,
    required this.name,
    required this.coverUrl,
    required this.creatorId,
    required this.places,
    required this.description,
  });

  factory CBRoute.fromJson(Map<String, dynamic> json) {
    return CBRoute(
      id: json['id'],
      name: json['name'],
      coverUrl: json['coverUrl'],
      creatorId: json['creatorId'],
      places: (json['places'] as List).map((e) => CBPlace.fromJson(e)).toList(),
      description: json['description'],
    );
  }

  @override
  Map<String, dynamic> toJson({bool withId = true}) {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['coverUrl'] = coverUrl;
    data['creatorId'] = creatorId;
    data['places'] = places.map((e) => e.toJson()).toList();
    data['description'] = description;
    return data;
  }
}
