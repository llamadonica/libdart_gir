part of libdart_gir;

abstract class Repository extends Object {
  Repository._intrinsic(GTypeDef intrinsic) : super.intrinsic(intrinsic);
  static Repository get $default => _Repository.$default;
  Typelib require(String namespace, [String version=null]);
  List<String> getDependencies(String namespace);
  int getNInfos(String namespace);
  BaseInfo getInfo(String namespace, int index);
}

class _Repository extends Repository {
  _Repository._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
  static _Repository get $default => new _Repository._intrinsic(_getDefault());
  Typelib require(String namespace, [String version=null]) => 
    new _Typelib._intrinsic(_require(this._intrinsic,namespace,version));
  List<String> getDependencies(String namespace) => 
    _get_dependencies(this._intrinsic,namespace);
  int getNInfos(String namespace) => 
    _get_n_infos(this._intrinsic,namespace);
  BaseInfo getInfo(String namespace, int index) => 
    _get_info(this._intrinsic,namespace,index);
  
  static GTypeDef _getDefault() native "dart_gir_repository_get_default";
  static GTypeDef _require(GTypeDef def, String namespace, [String version=null]) native "dart_gir_repository_require";
  static List<String> _get_dependencies(GTypeDef def, String namespace) native "dart_gir_repository_get_dependencies";
  static int _get_n_infos(GTypeDef def, String namespace) native "dart_gir_repository_get_n_infos";
  static BaseInfo _get_info(GTypeDef def, String namespace, int index) native "dart_gir_repository_get_info";
}