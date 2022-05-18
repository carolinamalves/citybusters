class StorageReferences {
  static String route(String routeId) => 'routes-content/$routeId';
  static String routeCover(String routeId) => route(routeId) + '/cover.png';
}
