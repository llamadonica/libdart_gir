part of libdart_gir;

abstract class Typelib extends TypedBase {
  Typelib._intrinsic(GTypeDef intrinsic) : super.intrinsic(intrinsic);
}

class _Typelib extends Typelib {
  _Typelib._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
}
