part of libdart_gir;

abstract class BaseInfo extends TypedBase implements GirVisitable {
  BaseInfo._intrinsic(GTypeDef intrinsic) : super.intrinsic(intrinsic);
  String get name native "dart_gir_base_info_get_name";
  String getAttribute (String attribute) native "dart_gir_base_info_get_attribute";
  AttributeCollection get attributes => new AttributeCollection(this);
  Future accept(ContainerDeclaration library_, GirVisitor visitor) {
    return visitor.visitBaseInfo (library_, this).then((_) {
      return;
    });
  }
}

class ConstantInfo extends BaseInfo {
  ConstantInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
  TypeInfo get type native "dart_gir_constant_info_get_type";
  dynamic get value native "dart_gir_constant_info_get_value";
}
class StructInfo extends BaseInfo {
  StructInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
  int childrenPending = 0;
  
  Future accept(ContainerDeclaration library_, GirVisitor visitor) {
    var completer = new Completer();
    visitor.visitBaseInfo (library_, this).then((decl) {
      if (decl.size > 0) {
        for (var e in fields) {
          childrenPending++;
          e.accept(decl, visitor).then((_) {
            if (--childrenPending == 0)
              completer.complete();
          });
        }
      } else {
        completer.complete();
      }
    });
    return completer.future;
  }
  int get size native "dart_gir_struct_info_get_size";
  int get _n_fields native "dart_gir_struct_info_get_n_fields";
  FieldInfo _get_n_field(int n) native "dart_gir_struct_info_get_field";
  Iterable<FieldInfo> get fields => 
      new Iterable<FieldInfo>.generate(_n_fields , _get_n_field);
}
class FlagsInfo extends BaseInfo {
  FlagsInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
}
class EnumInfo extends BaseInfo {
  EnumInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
  int childrenPending = 0;
  int get _n_values native "dart_gir_enum_info_get_n_values";
  TypeTag get storageType native "dart_gir_enum_info_get_storage_type" ;
  ValueInfo _get_value(int n) native "dart_gir_enum_info_get_value" ;
  Future accept(ContainerDeclaration library_, GirVisitor visitor) {
    var completer = new Completer();
    visitor.visitBaseInfo (library_, this).then((decl) {
      for (var e in values) {
        childrenPending++;
        e.accept(decl, visitor).then((_) {
          if (--childrenPending == 0)
            completer.complete();
        });
      }
    });
    return completer.future;
  }
  Iterable<ValueInfo> get values => 
      new Iterable<ValueInfo>.generate(_n_values , _get_value);
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
class TypeInfo extends BaseInfo {
  TypeInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
  TypeTag get tag native  "dart_gir_type_info_get_tag";
  ArrayType get arrayType native  "dart_gir_type_info_get_array_type";
  BaseInfo get interface native  "dart_gir_type_info_get_interface";
  int get arrayFixedSize native  "dart_gir_type_info_get_array_fixed_size";
  TypeInfo getParamType(int n) native  "dart_gir_type_info_get_param_type";
  
  
  String constTypeName() => tag.constTypeName();
  bool canBeTranslatedToConst() {
    return (
      tag.canBeTranslatedToField() ||
      tag == TypeTag.UTF8          ||
      tag == TypeTag.FILENAME);
  }
  bool canBeTranslatedToField() => tag.canBeTranslatedToField();
  String fieldGetterName(String bufferName, int offset) {
    if (tag.canBeTranslatedToField())
      return tag.fieldGetterName(bufferName, offset);
    return null;
  }
  String fieldSetterName(String bufferName, int offset, String valueVar) {
    if (tag.canBeTranslatedToField())
      return tag.fieldSetterName(bufferName, offset, valueVar);
    return null;
  }
}
class FieldInfo extends BaseInfo {
  FieldInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
  int get size native "dart_gir_field_info_get_size";
  int get offset native "dart_gir_field_info_get_offset";
  TypeInfo get type native "dart_gir_field_info_get_type";
  FieldInfoFlags get flags native "dart_gir_field_info_get_flags";
}
class ValueInfo extends BaseInfo {
  ValueInfo._intrinsic(GTypeDef intrinsic) : super._intrinsic(intrinsic);
  int get value native  "dart_gir_value_info_get_value";
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

class TypeTag {
  final int _code;
	static const TypeTag VOID = const TypeTag(0); 
  static const TypeTag BOOLEAN = const TypeTag(1);
  static const TypeTag INT8 = const TypeTag(2);
  static const TypeTag UINT8 = const TypeTag(3); 
  static const TypeTag INT16 = const TypeTag(4);
  static const TypeTag UINT16 = const TypeTag(5);
  static const TypeTag INT32 = const TypeTag(6);
  static const TypeTag UINT32 = const TypeTag(7);
  static const TypeTag INT64 = const TypeTag(8);
  static const TypeTag UINT64 = const TypeTag(9);
  static const TypeTag FLOAT = const TypeTag(10);
  static const TypeTag DOUBLE = const TypeTag(11);
  static const TypeTag GTYPE = const TypeTag(12);
  static const TypeTag UTF8 = const TypeTag(13);
  static const TypeTag FILENAME = const TypeTag(14);
  static const TypeTag ARRAY = const TypeTag(15);
  static const TypeTag INTERFACE = const TypeTag(16);
  static const TypeTag GLIST = const TypeTag(17);
  static const TypeTag GSLIST = const TypeTag(18);
  static const TypeTag GHASH = const TypeTag(19);
  static const TypeTag ERROR = const TypeTag(20);
	static const TypeTag UNICHAR = const TypeTag(21);
	const TypeTag(this._code);
	
	operator ==(TypeTag other) => this._code == other._code;
	int get hashCode => _code;
	String toString() native "dart_gir_type_tag_to_string";
	static TypeTag getNativeInt() {
    var _size = _getNativeIntSize();
    switch (_size) {
      case 1: return TypeTag.INT8;
      case 2: return TypeTag.INT16;
      case 4: return TypeTag.INT32;
      case 8: return TypeTag.INT64;
      default: throw new ArgumentError("Unexpected size of int/bool $_size");
    }
  }
  static int _getNativeIntSize() native "dart_gir_get_native_int_size";
  bool canBeTranslatedToField() {
    var tag_ = this;
    return (  
      tag_ == TypeTag.BOOLEAN ||
      tag_ == TypeTag.INT8 ||
      tag_ == TypeTag.UINT8 || 
      tag_ == TypeTag.INT16 ||
      tag_ == TypeTag.UINT16 ||
      tag_ == TypeTag.INT32 ||
      tag_ == TypeTag.UINT32 ||
      tag_ == TypeTag.INT64 ||
      tag_ == TypeTag.UINT64 ||
      tag_ == TypeTag.FLOAT ||
      tag_ == TypeTag.DOUBLE);
  }
  String constTypeName() {
    if (
      //tag_ == TypeTag.VOID || 
      this == TypeTag.BOOLEAN )
        return "boolean";
    if (
      this == TypeTag.INT8 ||
      this == TypeTag.UINT8 || 
      this == TypeTag.INT16 ||
      this == TypeTag.UINT16 ||
      this == TypeTag.INT32 ||
      this == TypeTag.UINT32 ||
      this == TypeTag.INT64 ||
      this == TypeTag.UINT64)
        return "int";
    if (
      this == TypeTag.FLOAT ||
      this == TypeTag.DOUBLE)
        return "double";
      //tag_ == TypeTag.GTYPE ||
    if (
      this == TypeTag.UTF8 ||
      this == TypeTag.FILENAME)
        return "String";
      //TODO: This needs special handling.
      //tag_ == TypeTag.ARRAY ||
      //tag_ == TypeTag.INTERFACE ||
      //tag_ == TypeTag.GLIST ||
      //tag_ == TypeTag.GSLIST ||
      //tag_ == TypeTag.GHASH ||
      //tag_ == TypeTag.ERROR ||
      //tag_ == TypeTag.UNICHAR);
    return null;
  }
  String fieldGetterName(String bufferName, int offset) {
    var tag_ = this;
    
    if (tag_ == TypeTag.BOOLEAN) {
      var basicStatement = getNativeInt().fieldGetterName(bufferName,offset);
      return "($basicStatement != 0)";
    }
    if (tag_ == TypeTag.INT8) return "$bufferName.getInt8($offset)";
    if (tag_ == TypeTag.UINT8) return "$bufferName.getUint8($offset)";
    if (tag_ == TypeTag.INT16) return "$bufferName.getInt16($offset)";
    if (tag_ == TypeTag.UINT16) return "$bufferName.getUint16($offset)";
    if (tag_ == TypeTag.INT32) return "$bufferName.getInt32($offset)";
    if (tag_ == TypeTag.UINT32) return "$bufferName.getUint32($offset)";
    if (tag_ == TypeTag.INT64) return "$bufferName.getInt64($offset)";
    if (tag_ == TypeTag.UINT64) return "$bufferName.getUint64($offset)";
    if (tag_ == TypeTag.FLOAT) return "$bufferName.getFloat32($offset)";
    if (tag_ == TypeTag.DOUBLE) return "$bufferName.getFloat64($offset)";
    return null;
  }
  String fieldSetterName(String bufferName, int offset, String valueVar) {
    var tag_ = this;
    
    if (tag_ == TypeTag.BOOLEAN) {
      var basicStatement = getNativeInt().fieldGetterName(bufferName,offset);
      return "($basicStatement != 0)";
    }
    if (tag_ == TypeTag.INT8) return "$bufferName.setInt8($offset,$valueVar)";
    if (tag_ == TypeTag.UINT8) return "$bufferName.setUint8($offset,$valueVar)";
    if (tag_ == TypeTag.INT16) return "$bufferName.setInt16($offset,$valueVar)";
    if (tag_ == TypeTag.UINT16) return "$bufferName.setUint16($offset,$valueVar)";
    if (tag_ == TypeTag.INT32) return "$bufferName.setInt32($offset,$valueVar)";
    if (tag_ == TypeTag.UINT32) return "$bufferName.setUint32($offset,$valueVar)";
    if (tag_ == TypeTag.INT64) return "$bufferName.setInt64($offset,$valueVar)";
    if (tag_ == TypeTag.UINT64) return "$bufferName.setUint64($offset,$valueVar)";
    if (tag_ == TypeTag.FLOAT) return "$bufferName.setFloat32($offset,$valueVar)";
    if (tag_ == TypeTag.DOUBLE) return "$bufferName.setFloat64($offset,$valueVar)";
    return null;
  }
}

class ArrayType {
  final int _index;
  final String _name;
	static const ArrayType C = const ArrayType._(0,'C'); 
  static const ArrayType ARRAY = const ArrayType._(1,'ARRAY');
  static const ArrayType PTR_ARRAY = const ArrayType._(2,'PTR_ARRAY');
  static const ArrayType BYTE_ARRAY = const ArrayType._(3,'BYTE_ARRAY'); 
  static List<ArrayType> values = [C,ARRAY,PTR_ARRAY,BYTE_ARRAY];
	const ArrayType._(this._index,this._name);
	factory ArrayType(int index) => values[index];
	
	operator ==(ArrayType other) => this._index == other._index;
	int get hashCode => _index;
	String toString() => _name;
}

class FieldInfoFlags { 
  final int _index;
	static FieldInfoFlags READABLE = new FieldInfoFlags(1);
  static FieldInfoFlags WRITABLE = new FieldInfoFlags(2);
	FieldInfoFlags(this._index);
	
	operator ==(FieldInfoFlags other) => this._index == other._index;
	operator |(FieldInfoFlags other) => new FieldInfoFlags(this._index | other._index);
	operator &(FieldInfoFlags other) => new FieldInfoFlags(this._index & other._index);
	
	bool get readable => (this & READABLE) == READABLE;
	bool get writable => (this & WRITABLE) == WRITABLE;
}