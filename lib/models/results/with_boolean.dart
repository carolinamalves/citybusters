import 'package:graphql_flutter/graphql_flutter.dart';

class WithBoolean {
  final bool status;
  final String? message;
  final bool? value;

  WithBoolean({
    required this.status,
    this.message,
    this.value,
  });

  static String qlType = 'PGRWithBoolean';

  bool get hasError => !status || value == null;

  static WithBoolean error({String? m}) =>
      WithBoolean(status: false, message: m);
  static WithBoolean success({bool? value, String? m}) =>
      WithBoolean(status: true, value: value, message: m);

  static WithBoolean parseQlRes(QueryResult? data, String method) {
    try {
      if (data == null || data.data == null) return WithBoolean.error();

      Map<String, dynamic>? _d = data.data?[method];
      if (_d == null || (_d['value'] ?? false) == false)
        return WithBoolean.error(m: _d?['message']);

      if (_d["__typename"] != WithBoolean.qlType) return WithBoolean.error();

      return WithBoolean(
          status: _d['status'], message: _d['message'], value: _d['value']);
    } catch (error) {
      return WithBoolean.error(m: error.toString());
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
