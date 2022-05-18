import 'package:citybusters/models/cb_model.dart';
import 'package:mobileapp_models/new_models/results/result_parser_utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class WithValues<T extends CBModel> {
  final bool status;
  final String? message;
  final List<T>? values;

  WithValues({required this.status, this.message, this.values});

  static String qlType = 'PGRWithValue';

  bool get hasError => !status;

  static WithValues error<T extends CBModel>({String? m}) =>
      WithValues<T>(status: false, message: m);

  static WithValues success<T extends CBModel>(
          {List<CBModel>? values, String? m}) =>
      WithValues(status: true, values: values, message: m);

  static WithValues<T> parseQlRes<T extends CBModel>(
    QueryResult? data,
    String method,
  ) {
    try {
      if (data == null || data.data == null)
        return WithValues<T>(status: false);

      Map<String, dynamic>? _d = data.data?[method];
      if (_d == null || (_d['values'] ?? false) == false)
        return WithValues<T>(
            status: false, message: _d?['message'], values: []);

      // if does not have values but is all good
      if (_d["status"] == true &&
          _d["values"] is List &&
          (_d["values"] as List).isEmpty)
        return WithValues<T>(status: _d["status"], values: []);

      if (_d["__typename"] != WithValues.qlType)
        return WithValues<T>(status: false);

      // proccess values
      List? values = _d['values'];
      if (values == null) return WithValues<T>(status: false);

      List<T> processedValues = [];
      String? _typeName;
      String? message;

      for (var val in values) {
        if (_typeName == null) {
          _typeName = val["__typename"];
          if (_typeName == null) throw Exception("could not resolve type");
        } else {
          if (_typeName != val["__typename"])
            throw Exception("could not resolve type");
        }

        var _vp = (ResultParserUtils.fromJsonType<T>(val, _typeName) as T?);
        if (_vp == null) {
          message = "swkipped value";
          continue;
        }

        processedValues.add(_vp);
      }

      if (_typeName == null) return WithValues<T>(status: false);

      return WithValues<T>(
        status: _d['status'],
        message: message ?? _d['message'],
        values: processedValues,
      );
    } on Exception catch (error) {
      print(error);
      return WithValues<T>(status: false, message: error.toString());
    } catch (error) {
      print(error);
      return WithValues<T>(status: false, message: error.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (message != null) data['message'] = message;
    if (values != null)
      data['values'] = values?.map((e) => e.toJson()).toList();
    return data;
  }
}
