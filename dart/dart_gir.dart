library libdart_gir;

import 'dart-ext:dart_gir';

class GObject {
}

class GIRepository extends GObject {
  //static GIRepository get default => _getDefault();
  static GIRepository _getDefault() native "dart_gir_repository_get_default";
  //List<String> get loadedNamespaces => _getLoadedNamespaces();
  List<String> _getLoadedNamespaces() native "dart_gir_repository_get_loaded_namespaces";
}

abstract class GIRVisitor {
  visitNamespace(GIRVisitable visitable);
  visitNamespace(GIRVisitable visitable);
}

abstract class GIRVisitable {
  void accept(GIRVisitor visitor);
}

main() {
  print(GIRepository._getDefault()._getLoadedNamespaces());
}
