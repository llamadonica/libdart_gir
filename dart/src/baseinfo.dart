part of libdart_gir;

abstract class BaseInfo extends TypedBase {
  BaseInfo._intrinsic(GTypeDef intrinsic) : super.intrinsic(intrinsic);
  String get name native "dart_gir_base_info_get_name";
  String getAttribute (String attribute) native "dart_gir_base_info_get_attribute";
  AttributeCollection get attributes => new AttributeCollection(this);
}

class ConstantInfo extends BaseInfo {
  ConstantInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
}
class StructInfo extends BaseInfo {
  StructInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
}
class FlagsInfo extends BaseInfo {
  FlagsInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
}
class EnumInfo extends BaseInfo {
  EnumInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
}
class CallbackInfo extends BaseInfo {
  CallbackInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
}
class UnionInfo extends BaseInfo {
  UnionInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
}
class FunctionInfo extends BaseInfo {
  FunctionInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
}

class _AttributeIterator extends TypedBase implements Iterator<BaseInfoAttribute> {
  final BaseInfo _baseInfo;
  String _attribute;
  String _value;
  _AttributeIterator._intrinsic(BaseInfo this._baseInfo, GTypeDef intrinsic) : super.intrinsic(intrinsic);
  static GTypeDef $new () native  "dart_gir_attribute_iter_new";
  static bool _iterateAttributes (BaseInfo _baseInfo, _AttributeIterator that) native "dart_gir_base_info_iterate_attributes";
  factory _AttributeIterator(BaseInfo _baseInfo) => new _AttributeIterator._intrinsic(_baseInfo, $new());
  
  bool moveNext() => _iterateAttributes(_baseInfo, this);
  BaseInfoAttribute get current => new BaseInfoAttribute(_attribute, _value);
}

class BaseInfoAttribute {
  final String attribute;
  final String value;
  const BaseInfoAttribute(String this.attribute, String this.value);
}

class AttributeCollection extends Iterable<BaseInfoAttribute> with IterableMixin<BaseInfoAttribute> {
  final BaseInfo _baseInfo;
  AttributeCollection (this._baseInfo);
  String operator [](String name) => _baseInfo.getAttribute(name);
  Iterator<BaseInfoAttribute> get iterator => new _AttributeIterator(_baseInfo);
}
