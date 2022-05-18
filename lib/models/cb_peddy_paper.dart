import 'package:citybusters/models/cb_model.dart';
import 'package:citybusters/models/cb_route.dart';

class CBPeddyPaper extends CBModel {
  final String id;
  final Map<String, String> passwords;
  final Map<String, String> descriptions;
  final CBRoute route;

  CBPeddyPaper({
    required this.id,
    required this.passwords,
    required this.descriptions,
    required this.route,
  });

  factory CBPeddyPaper.fromJson(Map<String, dynamic> json) {
    return CBPeddyPaper(
      id: json['id'],
      passwords: (json['passwords'] as Map)
          .map((key, value) => MapEntry(key as String, value as String)),
      descriptions: (json['descriptions'] as Map)
          .map((key, value) => MapEntry(key as String, value as String)),
      route: CBRoute.fromJson(json['route']),
    );
  }

  @override
  Map<String, dynamic> toJson({bool withId = true}) {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['passwords'] = passwords;
    data['descriptions'] = descriptions;
    data['route'] = route.toJson();
    return data;
  }
}
