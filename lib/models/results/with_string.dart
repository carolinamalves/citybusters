import 'package:graphql_flutter/graphql_flutter.dart';

class WithString {
  final bool status;
  final String? message;
  final String? value;

  WithString({
    required this.status,
    this.message,
    this.value,
  });

  static String qlType = 'PGRWithString';

  bool get hasError => !status || value == null;

  static WithString error({String? m}) => WithString(status: false, message: m);
  static WithString success({String? value, String? m}) =>
      WithString(status: true, value: value, message: m);

  static WithString parseQlRes(QueryResult? data, String method) {
    try {
      if (data == null || data.data == null) return WithString.error();

      Map<String, dynamic>? _d = data.data?[method];
      if (_d == null || (_d['value'] ?? false) == false)
        return WithString.error(m: _d?['message']);

      if (_d["__typename"] != WithString.qlType) return WithString.error();

      return WithString(
          status: _d['status'], message: _d['message'], value: _d['value']);
    } catch (error) {
      return WithString.error(m: error.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (message != null) data['message'] = message;
    if (value != null) data['value'] = value;
    return data;
  }
}
