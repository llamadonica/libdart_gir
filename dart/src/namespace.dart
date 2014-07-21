part of libdart_gir;

abstract class Namespace extends ListMixin<BaseInfo> implements List<BaseInfo> {
  List<String> get dependencies;
  String get namespace;
  factory Namespace (Repository repository,String namespace) =>
    new _Namespace(repository,namespace);
  Namespace._();
}

class _Namespace extends Namespace {
  final Repository _repository;
  final String _namespace;
  int childrenPending = 0;
  
  _Namespace(Repository this._repository,String this._namespace) : super._() {
    _repository.require(namespace);
  }
  
  List<String> get dependencies => _repository.getDependencies(namespace);
  String get namespace => _namespace;
  
  int get length => _repository.getNInfos(namespace);
  BaseInfo operator[](int index) => _repository.getInfo(namespace, index);
  operator[]=(int index, BaseInfo info) {
    throw new StateError("Namespace is an immutable list.");
  }
  void set length (int length) {
    throw new StateError("Namespace is an immutable list.");
  }
  
  Future<LibraryDeclaration> accept(GirVisitor visitor) {
    var library = visitor.visitNamespace (this);
    var completer = new Completer<LibraryDeclaration>();
    for (var i in dependencies)
      library.requireDependency(i);
    for (var i in this) {
      childrenPending++;
      i.accept(library, visitor).then((_) {
        if (--childrenPending == 0) {
          completer.complete(library);
        }
      });
    }
    return completer.future;
  }
}
