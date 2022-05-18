import 'package:citybusters/models/cb_model.dart';

class CBCUser extends CBModel {
  final String id;
  final String name;
  final String email;

  CBCUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory CBCUser.fromJson(Map<String, dynamic> json) {
    return CBCUser(id: json['id'], name: json['name'], email: json['email']);
  }

  @override
  Map<String, dynamic> toJson({bool withId = true}) {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
