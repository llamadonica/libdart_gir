part of libdart_gir;

class GTypeDef extends NativeFieldWrapperClass2 {}

abstract class TypedBase {
  final GTypeDef _intrinsic;
  TypedBase.intrinsic(GTypeDef this._intrinsic);
}

abstract class Object extends TypedBase {
  Object.intrinsic(GTypeDef intrinsic) : super.intrinsic(intrinsic);
}
