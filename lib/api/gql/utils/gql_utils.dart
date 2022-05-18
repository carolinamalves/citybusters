import 'package:citybusters/services/init_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GqlUtils {
  static Future<QueryResult?> query({
    required String queryString,
    Map<String, dynamic> variables = const <String, dynamic>{},
    FetchPolicy fetchPolicy = FetchPolicy.noCache,
    Duration? pollInterval,
  }) async {
    try {
      final query = QueryOptions(
        document: gql(queryString),
        fetchPolicy: fetchPolicy,
        variables: variables,
        pollInterval: pollInterval,
      );

      final result = await QlClient.value
          .query(query)
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw Exception;
      });
      if (result.hasException) return null;

      return result;
    } catch (e) {
      // print(e);
      return null;
    }
  }

  static Future<QueryResult?> mutation({
    required String mutationString,
    Map<String, dynamic> variables = const <String, dynamic>{},
    FetchPolicy fetchPolicy = FetchPolicy.networkOnly,
  }) async {
    try {
      final mutation = MutationOptions(
        document: gql(mutationString),
        fetchPolicy: fetchPolicy,
        variables: variables,
      );

      final result = await QlClient.value
          .mutate(mutation)
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw Exception;
      });

      if (result.hasException) {
        // print(result.exception);
        return null;
      }

      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
