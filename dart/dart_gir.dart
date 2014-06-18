library libdart_gir;

import 'dart-ext:dart_gir';

abstract class TypedBase {
  final GTypeDef _intrinsic;
  TypedBase.intrinsic(GTypeDef this._intrinsic);
}

abstract class Object extends TypedBase {
  Object.intrinsic(GTypeDef intrinsic) : super.intrinsic(intrinsic);
}

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
  
  static GTypeDef _getDefault() native "dart_gir_repository_get_default";
  static GTypeDef _require(GTypeDef def, String namespace, [String version=null]) native "dart_gir_repository_require";
}

abstract class Typelib extends TypedBase {
  Typelib._intrinsic(GTypeDef intrinsic) : super.intrinsic(intrinsic);
}

class _Typelib extends Typelib {
  _Typelib._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
}

main() {
  Repository.$default.require("GLib");
}
