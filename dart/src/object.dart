part of libdart_gir;

abstract class TypedBase {
  final GTypeDef _intrinsic;
  TypedBase.intrinsic(GTypeDef this._intrinsic);
}

abstract class Object extends TypedBase {
  Object.intrinsic(GTypeDef intrinsic) : super.intrinsic(intrinsic);
}
