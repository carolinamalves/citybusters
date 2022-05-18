import 'package:citybusters/models/cb_model.dart';
import 'package:mobileapp_models/new_models/results/result_parser_utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class WithValue<T extends CBModel> {
  final bool status;
  final String? message;
  final T? value;

  WithValue({required this.status, this.message, this.value});

  static String qlType = 'PGRWithValue';

  bool get hasError => !status || value == null;

  static WithValue error<T extends CBModel>({String? m}) =>
      WithValue<T>(status: false, message: m);

  static WithValue success<T extends CBModel>({T? value, String? m}) =>
      WithValue(status: true, value: value, message: m);

  static WithValue<T> parseQlRes<T extends CBModel>(
    QueryResult? data,
    String method,
  ) {
    try {
      if (data == null || data.data == null) return WithValue<T>(status: false);

      Map<String, dynamic>? _d = data.data?[method];
      if (_d == null || (_d['value'] ?? false) == false)
        return WithValue<T>(status: false, message: _d?['message']);

      if (_d["__typename"] != WithValue.qlType)
        return WithValue<T>(status: false);

      String? _typeName = _d['value']["__typename"];
      if (_typeName == null) {
        final _msg = "Error processing typename";
        return WithValue<T>(status: false, message: _msg);
      }

      final val =
          (ResultParserUtils.fromJsonType<T>(_d['value'], _typeName) as T?);
      return WithValue<T>(
          status: _d['status'], message: _d['message'], value: val);
    } catch (error) {
      return WithValue<T>(status: false, message: error.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (message != null) data['message'] = message;
    if (value != null) data['value'] = value?.toJson();
    return data;
  }
}
