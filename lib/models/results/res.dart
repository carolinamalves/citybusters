import 'package:graphql_flutter/graphql_flutter.dart';

class Res {
  final bool status;
  final String? message;

  Res({
    required this.status,
    this.message,
  });

  static String qlType = 'PGRRes';

  static Res error({String? m}) => Res(status: false, message: m);
  static Res success({String? m}) => Res(status: true, message: m);

  static Res parseQlRes(QueryResult? data, String method) {
    try {
      if (data == null || data.data == null) return Res.error();

      Map<String, dynamic>? _d = data.data?[method];
      if (_d == null) return Res.error(m: _d?['message']);

      if (_d["__typename"] != Res.qlType) return Res.error();

      return Res(status: _d['status'], message: _d['message']);
    } catch (error) {
      return Res.error(m: error.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (message != null) data['message'] = message;
    return data;
  }
}
