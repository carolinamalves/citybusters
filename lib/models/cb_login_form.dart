import 'package:citybusters/models/cb_model.dart';

class CBCreateUserForm extends CBModel {
  final String userId;
  final String name;
  final String email;

  CBCreateUserForm({
    required this.userId,
    required this.name,
    required this.email,
  });

  factory CBCreateUserForm.fromJson(Map<String, dynamic> json) {
    return CBCreateUserForm(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
    );
  }

  @override
  Map<String, dynamic> toJson({bool withId = true}) {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
