class GqlQueryUtils {
  // results
  static String _with = '''
    status
    message
  ''';

  static String res = '''
    {
      ${GqlQueryUtils._with}
    }
  ''';

  static String withBoolean = '''
    {
      ${GqlQueryUtils._with}
      value
    }
  ''';

  static String withString = '''
    {
      ${GqlQueryUtils._with}
      value
    }
  ''';

  static String withValue(String on) => '''
    {
      ${GqlQueryUtils._with}
      value {
        ... on $on
      }
    }
  ''';

  static String withValues(String on) => '''
    {
      ${GqlQueryUtils._with}
      values {
        ... on $on
      }
    }
  ''';

  // types

  static String User = '''
    {
      id
      name
      email
    }
  ''';
}
