import 'package:citybusters/models/cb_model.dart';

class ResultParserUtils {
  static Object? fromJsonType<T extends CBModel>(
      Map<String, dynamic>? _d, String typename) {
    if (_d == null) return null;
    switch (typename) {
      default:
        print("unable to resolve type. -> " + typename);
        return null;
    }
  }
}
