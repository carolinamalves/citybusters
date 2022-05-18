import 'package:citybusters/api/gql/utils/gql_utils.dart';

class TestGraphQl {
  static testCreateUser() async {
    final res = await GqlUtils.mutation(mutationString: '''
    mutation createUser(){
      createUser(){

      }
    }
    ''');
    print(res);
  }
}
