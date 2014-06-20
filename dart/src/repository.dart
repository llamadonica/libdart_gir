part of libdart_gir;

abstract class Repository extends Object {
  Repository._intrinsic(GTypeDef intrinsic) : super.intrinsic(intrinsic);
  static Repository get $default => _Repository.$default;
  Typelib require(String namespace, [String version=null]);
}

class _Repository extends Repository {
  _Repository._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
  static _Repository get $default => new _Repository._intrinsic(_getDefault());
  Typelib require(String namespace, [String version=null]) => 
    new _Typelib._intrinsic(_require(this._intrinsic,namespace,version));
  List<String> getDependencies(String namespace) => 
    _get_dependencies(this._intrinsic,namespace);
  
  static GTypeDef _getDefault() native "dart_gir_repository_get_default";
  static GTypeDef _require(GTypeDef def, String namespace, [String version=null]) native "dart_gir_repository_require";
  static GTypeDef _get_dependencies(GTypeDef def, String namespace) native "dart_gir_repository_get_dependencies";
}