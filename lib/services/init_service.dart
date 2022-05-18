import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

late final ValueNotifier<GraphQLClient> QlClient;

class InitService {
  static Future init() async {
    await Hive.initFlutter();
    final HttpLink httpLink = HttpLink("http://192.168.1.71:5000");

    final graphQlBox = await HiveStore.openBox('graphql-cache');
    QlClient = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(
          store: HiveStore(graphQlBox),
        ),
      ),
    );
  }
}
