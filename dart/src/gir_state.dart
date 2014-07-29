part of libdart_gir;

class GirGlobalState {
  static const bool DEBUG = true;
  Map<String,String> packageUris = new Map<String,String>();
  Map<String,String> trueUris = new Map<String,String>();
  
  void warn(String string) =>
    print("//" + string);
  void debug(String string) {
    if (DEBUG)
      print("//" + string);
  }
  void mapDependency (String giPackage, String packageUri, [String trueUri = null]) {
    if (trueUri == null)
      trueUri = packageUri;
    packageUris[giPackage] = packageUri;
    trueUris[giPackage] = trueUri;
  }
}

class TypeId {
  final int index;
  final String _name;
  const TypeId(this.index, this._name);
 
  static const TRANSPARENT_STRUCT = const TypeId(0,'TRANSPARENT_STRUCT');
  static const OPAQUE_STRUCT = const TypeId(1,'OPAQUE_STRUCT');
  static const OBJECT = const TypeId(2,'OPAQUE_STRUCT');
  static const DELEGATE = const TypeId(3,'DELEGATE');
  static const ENUM = const TypeId(4,'ENUM');
 
  static const values = const <TypeId>[TRANSPARENT_STRUCT, OPAQUE_STRUCT, 
      OBJECT, DELEGATE, ENUM]; 
  String toString() => values[index]._name;
  bool operator==(TypeId other) => this.index == other.index;
}

abstract class TypeDeclaration implements DartDeclaration {
  TypeId get typeId;
}

abstract class DartDeclaration {
  String toString ();
  String get name;
  void set name(String value);
  final BaseInfo baseSource;
  LibraryDeclaration get topLibrary;
  DartDeclaration ([BaseInfo this.baseSource = null]);
}
abstract class ContainerDeclaration extends DartDeclaration {
  void addDeclaration(DartDeclaration decl);
  ContainerDeclaration ([BaseInfo baseSource = null]) : super (baseSource);
}
class LibraryDeclaration extends ContainerDeclaration {
  List<DartDeclaration> _declarations = new List<DartDeclaration>();
  List<ImportDeclaration> _imports = new List<ImportDeclaration>();
  Map<String, TypeDeclaration> _types = new HashMap<String,TypeDeclaration>();
  
  final GirGlobalState _state;
  String _name;
  String get name => _name;
  void set name(String value) {_name = value;}
  LibraryDeclaration get topLibrary => this;

  LibraryDeclaration(GirGlobalState this._state) : super();
  
  void addDeclaration(DartDeclaration decl) {
    _declarations.add(decl);
    if (decl is TypeDeclaration) {
      _types[decl.baseSource.name] = decl;
    }
    print(decl.toString());
  }
  void requireDependency(String name) {
    var uri = _state.trueUris[name];
    if (uri == null)
      throw new GirStateError("Could not find library [$name]");
    var importDecl = new ImportDeclaration(this);
    
    importDecl.name = name;
    importDecl.uri = uri;
    _imports.add(importDecl);
    currentMirrorSystem().findLibrary(new Symbol(name));
  }
  
  bool bufferStringPointerGetterIsPresent = false;
  void assertBufferStringPointerGetterIsPresent () {
    if (bufferStringPointerGetterIsPresent) return;
    var decl = new NativeFunctionDeclaration(this,"_peekStringFromBuffer",
        "dart_gir_peek_string_from_buffer", "String",[]);
    addDeclaration(decl);
    bufferStringPointerGetterIsPresent = true;
  }
  
  bool bufferStringPointerSetterIsPresent = false;
  void assertBufferStringPointerSetterIsPresent () {
    if (bufferStringPointerSetterIsPresent) return;
    var decl = new NativeFunctionDeclaration(this,"_pokeStringToBuffer",
        "dart_gir_poke_string_to_buffer", "void",[]);
    addDeclaration(decl);
    bufferStringPointerSetterIsPresent = true;
  }
  
  bool bufferBufferPointerGetterIsPresent = false;
  void assertBufferPointerGetterIsPresent () {
    if (bufferBufferPointerGetterIsPresent) return;
    var decl = new NativeFunctionDeclaration(this,"_peekBufferFromBuffer",
        "dart_gir_peek_buffer_from_buffer", "ByteBuffer",[]);
    addDeclaration(decl);
    bufferBufferPointerGetterIsPresent = true;
  }
  
  bool bufferBufferPointerSetterIsPresent = false;
  void assertBufferPointerSetterIsPresent () {
    if (bufferBufferPointerSetterIsPresent) return;
    var decl = new NativeFunctionDeclaration(this,"_pokeBufferToBuffer",
        "dart_gir_poke_buffer_to_buffer", "void",[]);
    addDeclaration(decl);
    bufferBufferPointerSetterIsPresent = true;
  }
  
  String fieldGetterName(TypeInfo typeInfo, String bufferName, int offset) {
    if (typeInfo.tag == TypeTag.UTF8 || typeInfo.tag == TypeTag.FILENAME) {
      assertBufferStringPointerGetterIsPresent ();
      return "_peekStringFromBuffer ($bufferName, $offset)";
    }
    var name = typeInfo.fieldGetterName(bufferName, offset);
    if (name != null) return name;
    if (typeInfo.tag == TypeTag.ARRAY) {
      var innerType = typeInfo.getParamType(0);
      var fixedSize = typeInfo.arrayFixedSize;
      if (typeInfo.arrayType == ArrayType.C && fixedSize > 0 &&
          (innerType.tag == TypeTag.INT8 || innerType.tag == TypeTag.UINT8 || 
          innerType.tag == TypeTag.INT16 || innerType.tag == TypeTag.UINT16 || 
          innerType.tag == TypeTag.INT32 ||  innerType.tag == TypeTag.UINT32 || 
          innerType.tag == TypeTag.INT64 || innerType.tag == TypeTag.UINT64 || 
          innerType.tag == TypeTag.FLOAT || innerType.tag == TypeTag.DOUBLE)) {
        var type = typeName(typeInfo);
        return "new $type.view ($bufferName, $offset, $fixedSize)";
      }
    }

    if (typeInfo.tag == TypeTag.GSLIST || typeInfo.tag == TypeTag.GLIST) {
      assertBufferPointerGetterIsPresent ();
      String underlyingTypeName;
      if (typeInfo.tag == TypeTag.GSLIST) {
        underlyingTypeName = "SList";
      } else {
        underlyingTypeName = "List";
      }
      var varType = _types[underlyingTypeName];
      if (varType == null) {
        return null;
      }
      if (varType.typeId == TypeId.TRANSPARENT_STRUCT) {
        assertBufferPointerGetterIsPresent ();
        var underlyingSize = (varType as StructDeclaration).size;
        var tn = typeName(typeInfo);
        return "new $tn._(_peekBufferFromBuffer ($bufferName, $offset, $underlyingSize))";
      }
    }
    if (typeInfo.tag == TypeTag.GHASH) {
      var innerTypeA = typeInfo.getParamType(0);
      var innerTypeB = typeInfo.getParamType(1);
      var underlyingTypeName = "HashTable";
      var varType = _types[underlyingTypeName];
      if (varType == null) {
        return null;
      }
      if (varType.typeId == TypeId.TRANSPARENT_STRUCT) {
        assertBufferPointerGetterIsPresent ();
        var underlyingSize = (varType as StructDeclaration).size;
        var tn = typeName(typeInfo);
        return "new $tn._(_peekBufferFromBuffer ($bufferName, $offset, $underlyingSize))";
      }
    }
    if (typeInfo.tag == TypeTag.INTERFACE) {
      var underlyingTypeInfo = typeInfo.interface;
      var varType = _types[underlyingTypeInfo.name];
      if (varType == null) {
        return null;
      }
      if (varType.typeId == TypeId.TRANSPARENT_STRUCT) {
        assertBufferPointerGetterIsPresent ();
        var underlyingSize = (varType as StructDeclaration).size;
        var tn = typeName(typeInfo);
        return "new $tn._(_peekBufferFromBuffer ($bufferName, $offset, $underlyingSize))";
      }
      if (varType.typeId == TypeId.ENUM) {
        var tn = typeName(typeInfo);
        var subtype = (varType as EnumDeclaration).type.fieldGetterName(bufferName, offset);
        return "new $tn($subtype)";
      }
    }
    return null;
  }
  String fieldSetterName(TypeInfo typeInfo, String bufferName, int offset, String valueVar) {
    if (typeInfo.tag == TypeTag.UTF8 || typeInfo.tag == TypeTag.FILENAME) {
      assertBufferStringPointerSetterIsPresent ();
      return "_pokeStringToBuffer ($bufferName, $offset, $valueVar)";
    }
    var name = typeInfo.fieldSetterName(bufferName, offset, valueVar);
    if (name != null) return name;
    
    if (typeInfo.tag == TypeTag.GSLIST || typeInfo.tag == TypeTag.GLIST) {
      String underlyingTypeName;
      if (typeInfo.tag == TypeTag.GSLIST) {
        underlyingTypeName = "SList";
      } else {
        underlyingTypeName = "List";
      }
      var varType = _types[underlyingTypeName];
      if (varType == null) {
        return null;
      }
      if (varType.typeId == TypeId.TRANSPARENT_STRUCT) {
        assertBufferPointerGetterIsPresent ();
        var underlyingSize = (varType as StructDeclaration).size;
        var tn = typeName(typeInfo);
        return "_pokeBufferToBuffer ($bufferName, $offset, $underlyingSize, $valueVar.buffer))";
      }
    }
    
    if (typeInfo.tag == TypeTag.INTERFACE) {
      var underlyingTypeInfo = typeInfo.interface;
      var varType = _types[underlyingTypeInfo.name];
      if (varType == null) {
        return null;
      }
      if (varType.typeId == TypeId.TRANSPARENT_STRUCT) {
        assertBufferPointerGetterIsPresent ();
        var underlyingSize = (varType as StructDeclaration).size;
        var tn = typeName(typeInfo);
        return "_pokeBufferToBuffer ($bufferName, $offset, $underlyingSize, $valueVar.buffer))";
      }
      if (varType.typeId == TypeId.ENUM) {
        return (varType as EnumDeclaration).type.fieldSetterName(bufferName, offset,"$valueVar.index");
      }
    }
    return null;
  }
  String typeName(TypeInfo typeInfo) {
    var name = typeInfo.constTypeName();
    if (name != null) return name;
    if (typeInfo.tag == TypeTag.ARRAY) {
      if (typeInfo.arrayType == ArrayType.BYTE_ARRAY) 
        return "ByteArray";
      var innerType = typeInfo.getParamType(0);
      if (typeInfo.arrayType == ArrayType.C && typeInfo.arrayFixedSize > 0 &&
          innerType.tag == TypeTag.INT8)
        return "Int8List";
      if (typeInfo.arrayType == ArrayType.C && typeInfo.arrayFixedSize > 0 &&
          innerType.tag == TypeTag.UINT8)
        return "Uint8List";
      if (typeInfo.arrayType == ArrayType.C && typeInfo.arrayFixedSize > 0 &&
          innerType.tag == TypeTag.INT16)
        return "Int16List";
      if (typeInfo.arrayType == ArrayType.C && typeInfo.arrayFixedSize > 0 &&
          innerType.tag == TypeTag.UINT16)
        return "Uint16List";
      if (typeInfo.arrayType == ArrayType.C && typeInfo.arrayFixedSize > 0 &&
          innerType.tag == TypeTag.INT32)
        return "Int32List";
      if (typeInfo.arrayType == ArrayType.C && typeInfo.arrayFixedSize > 0 &&
          innerType.tag == TypeTag.UINT32)
        return "Uint32List";
      if (typeInfo.arrayType == ArrayType.C && typeInfo.arrayFixedSize > 0 &&
          innerType.tag == TypeTag.INT64)
        return "Int64List";
      if (typeInfo.arrayType == ArrayType.C && typeInfo.arrayFixedSize > 0 &&
          innerType.tag == TypeTag.UINT64)
        return "Uint64List";
      if (typeInfo.arrayType == ArrayType.C && typeInfo.arrayFixedSize > 0 &&
          innerType.tag == TypeTag.FLOAT)
        return "Float32List";
      if (typeInfo.arrayType == ArrayType.C && typeInfo.arrayFixedSize > 0 &&
          innerType.tag == TypeTag.DOUBLE)
        return "Float64List";
      /*tag_ == TypeTag.UINT16 ||
      tag_ == TypeTag.INT32 ||
      tag_ == TypeTag.UINT32 ||
      tag_ == TypeTag.INT64 ||
      tag_ == TypeTag.UINT64 ||
      tag_ == TypeTag.FLOAT ||
      tag_ == TypeTag.DOUBLE);) 
      */
      
      //The rest are largely dependent on types.
      var innerTypeName = typeName(typeInfo.getParamType(0));
      if (innerTypeName == null) {
        return null;
      }
      if (typeInfo.arrayType == ArrayType.BYTE_ARRAY) 
        return "ByteArray";
      if (typeInfo.arrayType == ArrayType.ARRAY) 
        return "Array<$innerType>";
      if (typeInfo.arrayType == ArrayType.PTR_ARRAY) 
        return "GenericArray<$innerType>";
      return "List<$innerType>";
    }
    if (typeInfo.tag == TypeTag.GLIST) {
      var innerTypeName = typeName(typeInfo.getParamType(0));
      return "GList";
    }
    if (typeInfo.tag == TypeTag.GSLIST) {
      var innerTypeName = typeName(typeInfo.getParamType(0));
      return "SList";
    }
    if (typeInfo.tag == TypeTag.GHASH) {
      return "HashTable";
    }
    if (typeInfo.tag == TypeTag.INTERFACE) {
      var underlyingTypeInfo = typeInfo.interface;
      var varType = _types[underlyingTypeInfo.name];
      if (varType == null) {
        print("//Could not find type ${underlyingTypeInfo.name}");
        return null;
      }
      return _types[underlyingTypeInfo.name].name;
    }
    print(typeInfo.tag);
    return null;
  }
}

class ImportDeclaration extends DartDeclaration {
  
  final LibraryDeclaration _topLibrary;
  LibraryDeclaration get topLibrary => _topLibrary;
  ImportDeclaration (LibraryDeclaration this._topLibrary) : super();
  
  String _name;
  String get name => _name;
  void set name(String value) {_name = value;}
  
  String _uri;
  String get uri => _uri;
  void set uri(String value) {_uri = value;}
  
  String toString () =>
    "import '$uri' as $name;";
}
abstract class DartTopOrOptionalClassDeclaration extends DartDeclaration {
  final LibraryDeclaration _topLibrary;
  LibraryDeclaration get topLibrary => _topLibrary;
  String get className;
  void set className(String value);

  DartTopOrOptionalClassDeclaration (LibraryDeclaration this._topLibrary, 
      BaseInfo baseSource) : super(baseSource);
}

class ConstDeclaration extends DartTopOrOptionalClassDeclaration {
  String _name;
  String get name => _name;
  void set name(String value) {
    _name = value;
  }
  
  String _className;
  String get className => _className;
  void set className(String value) {
    _className = value;
  }
  
  String type;
  dynamic value;
  
  ConstDeclaration (LibraryDeclaration _topLibrary, BaseInfo baseSource, String this._name, 
      String this.type, dynamic this.value, [String this._className = null]) :
      super(_topLibrary, baseSource);
  String toString() {
    var buffer = new StringBuffer();
    if (className != null)
      buffer.write("static ");
    buffer.write("const ");
    buffer.write(type);
    buffer.write(" ");
    buffer.write(name);
    buffer.write(" = ");
    if (value is String) {
      buffer.write(stringToStringReference(value));
    }
    else {
      buffer.write(value);
    }
    buffer.write(";");
    return buffer.toString();
  }
}
class StructDeclaration extends ContainerDeclaration implements TypeDeclaration {
  TypeId get typeId => TypeId.TRANSPARENT_STRUCT;
  
  final LibraryDeclaration _topLibrary;
  LibraryDeclaration get topLibrary => _topLibrary;
  String _name;
  String get name => _name;
  void set name(String value) {
    _name = value;
  }
  List<DartDeclaration> _fields = new List<DartDeclaration>();
  
  int size;      //The size is always rounded up to the alignment here. It might
                 //be possible to smush some extra bytes in there, but why bother?
  bool _hasGenerator;
  
  StructDeclaration (LibraryDeclaration this._topLibrary, 
      BaseInfo baseSource, String this._name) : super(baseSource);
  String toString() {
    String baseType;
    return """
class $name extends TypedData {
}""";
  }
  void addDeclaration(DartDeclaration decl) {
    _fields.add(decl);
    print(decl.toString());
  }
}
class EnumDeclaration extends ContainerDeclaration implements TypeDeclaration {
  TypeId get typeId => TypeId.ENUM;
  
  final LibraryDeclaration _topLibrary;
  LibraryDeclaration get topLibrary => _topLibrary;

  String _name;
  String get name => _name;
  void set name(String value) {
    _name = value;
  }

  TypeTag _type;
  TypeTag get type => _type;
  void set type(TypeTag value) {
    _type = value;
  }
  
  final bool isFlag;

  List<DartDeclaration> _values = new List<DartDeclaration>();
  
  EnumDeclaration (LibraryDeclaration this._topLibrary,  BaseInfo baseSource,
      String this._name, bool this.isFlag) : super(baseSource) {
    print("// $_name: $isFlag");
  }
  String toString() {
    String baseType;
    String flagPart = isFlag?"""

  $name(${type.constTypeName()} this._index) : _name = null;
  $name operator|($name other) => new $name(this._index | other._index);
  $name operator&($name other) => new $name(this._index & other._index);""":"";
    return """
class $name {
  final ${type.constTypeName()} _index;
  final ${type.constTypeName()} get index => _index;
  final String _name;
  const $name._(${type.constTypeName()} this._index, String this._name);
  boolean operator==($name other) => this._index == other._index;$flagPart
}
""";
  }
  void addDeclaration(DartDeclaration decl) {
    _values.add(decl);
    print(decl.toString());
  }
}
class DelegateDeclaration extends ContainerDeclaration implements TypeDeclaration {
  TypeId get typeId => TypeId.DELEGATE;
  
  final LibraryDeclaration _topLibrary;
  LibraryDeclaration get topLibrary => _topLibrary;

  String _name;
  String get name => _name;
  void set name(String value) {
    _name = value;
  }

  
  String _returnType;
  String get returnType => _returnType;
  void set returnType(String value) {
    _returnType = value;
  }

  List<DartDeclaration> _args = new List<DartDeclaration>();
  
  DelegateDeclaration (LibraryDeclaration this._topLibrary,  BaseInfo baseSource,
      String this._name) : super(baseSource);
      
  String toString() {
    return """typedef $_returnType $name ()""";
  }
  void addDeclaration(DartDeclaration decl) {
    _args.add(decl);
    print(decl.toString());
  }
}

class FieldDeclaration extends DartDeclaration {
  final LibraryDeclaration _topLibrary;
  LibraryDeclaration get topLibrary => _topLibrary;
  String _name;
  String get name => _name;
  void set name(String value) {
    _name = value;
  }
  
  int size;      //The size is always rounded up to the alignment here. It might
                 //be possible to smush some extra bytes in there, but why bother?
  int offset;
  int _type; 
  String wrapperName;
  bool hasGetter = false;
  bool hasSetter = false;
  String fieldSetter;
  String fieldGetter;
  String type;
  
  FieldDeclaration (LibraryDeclaration this._topLibrary, 
      BaseInfo baseSource, String this._name) : super(baseSource);
  String toString() {
    var output = new StringBuffer();
    if (hasGetter) {
      output.write("$type get $name => $fieldGetter;");
      if (hasSetter)
        output.write("\n");
    }
    if (hasSetter) {
      output.write("void set $name($type __value__) { $fieldSetter;}");
    }
    return output.toString();
  }
}
class EnumValueDeclaration extends DartDeclaration {
  final LibraryDeclaration _topLibrary;
  LibraryDeclaration get topLibrary => _topLibrary;
  String _name;
  int _value;
  final EnumDeclaration _type;
  
  String get name => _name;
  void set name(String value) {
    _name = value;
  }
  int get value => _value;
  void set value(int value_) {
    _value = value_;
  }

  EnumValueDeclaration (LibraryDeclaration this._topLibrary, 
      BaseInfo baseSource, String this._name, EnumDeclaration this._type)
      : super(baseSource);
  String toString() => 
      "static const ${_type.name} $name = const ${_type.name}._("
      "$_value,${stringToStringReference (name)});";
}

class NativeFunctionDeclaration extends DartTopOrOptionalClassDeclaration {
  String _className;
  String get className => _className;
  void set className(String value) {
    _className = value;
  }
  
  String _name;
  String get name => _name;
  void set name(String value) {_name = value;}
  
  String nativeFunction; 
  String type;
  List<ArgumentExpression> argumentExpressions;
  List<ArgumentExpression> namedArguments;
  
  NativeFunctionDeclaration (LibraryDeclaration _topLibrary, 
      String this._name, String this.nativeFunction, String this.type,
      List<ArgumentExpression> this.argumentExpressions,
      [List<ArgumentExpression> this.namedArguments = null]) : super(_topLibrary,
      null); 
  String toString() {
    var buffer = new StringBuffer('$type $name');
    if (!name.startsWith('get ')) {
      buffer.write('(');
      var iterator = argumentExpressions.iterator;
      bool isInOptional = false;
      bool hasPositional = false;
      if (iterator.moveNext()) {
        hasPositional = true;
        if (iterator.current.hasDefault) {
          isInOptional = true;
          buffer.write('[');
          buffer.write(iterator.current.toStringWithDefault());
        } else {
          buffer.write(iterator.current);
        }
        while (iterator.moveNext()) {
          buffer.write(', ');
          if (isInOptional) {
            buffer.write(iterator.current.toStringWithDefault());
          } else if (iterator.current.hasDefault) {
            isInOptional = true;
            buffer.write('[');
            buffer.write(iterator.current.toStringWithDefault());
          } else {
            buffer.write(iterator.current);
          }
        }
        if (isInOptional) buffer.write(']');
      }
      if (namedArguments != null && namedArguments.isNotEmpty) {
        if (isInOptional) throw new GirStateError("Named parameters and"
            "positional parameters cannot coexist in $name.");
        if (hasPositional) buffer.write(',');
        buffer.write('{');
        iterator = namedArguments.iterator;
        iterator.moveNext();
        buffer.write(iterator.current.toStringAsNamed());
        while (iterator.moveNext()) {
          buffer.write(', ');
          buffer.write(iterator.current.toStringAsNamed());
        }
        buffer.write('}');
      }
      buffer.write(') ');
    } else {
      if (argumentExpressions != null && argumentExpressions.isNotEmpty)
        throw new GirStateError("Getters can't have an argument expression.");
      if (namedArguments != null && namedArguments.isNotEmpty)
        throw new GirStateError("Getters can't have an argument expression.");
      buffer.write(' ');
    }
    buffer.write('native ');
    buffer.write(stringToStringReference(nativeFunction));
    buffer.write(';');
    return buffer.toString();
  }
}

class ArgumentExpression extends DartDeclaration {
  dynamic _type;
  String get name => _name;
  void set name(String value) {
    _name = value;
  }
  String _name;
  dynamic defaultValue;
  bool hasDefault;
  final LibraryDeclaration _topLibrary;
  LibraryDeclaration get topLibrary => _topLibrary;
  
  ArgumentExpression(LibraryDeclaration this._topLibrary, this._type,
      String this._name, [bool this.hasDefault = false,
      this.defaultValue = null]);
  String toString() {
    String typeName;
    if (_type is String) {
      typeName = _type;
    } else {
      typeName = _topLibrary.typeName(_type);
    }
    return "$typeName $name";
  }
  String toStringWithDefault() {
    String typeName;
    if (_type is String) {
      typeName = _type;
    } else {
      _topLibrary.typeName(_type);
    }
    var result = new StringBuffer("$typeName $name");
    if (hasDefault) {
      result.write(' = ');
      if (defaultValue is String) {
        result.write(stringToStringReference(defaultValue));
      }
      else {
        result.write(defaultValue);
      }
    } else {
      throw new GirStateError("Argument $name doesn't have a default value.");
    }
    return result.toString();
  }
  String toStringAsNamed () {
    String typeName;
    if (_type is String) {
      typeName = _type;
    } else {
      _topLibrary.typeName(_type);
    }
    var result = new StringBuffer("$typeName $name");
    if (hasDefault) {
      result.write(': ');
      if (defaultValue is String) {
        result.write(stringToStringReference(defaultValue));
      }
      else {
        result.write(defaultValue);
      }
    } else {
      throw new GirStateError("Argument $name doesn't have a default value.");
    }
    return result.toString();
  }
}

String stringToStringReference (String value) {
  var buffer = new StringBuffer('"');
  buffer.writeAll(
    value.runes.map((charCode) {
      if (charCode >= 32 &&  //Non-printing
          charCode < 127 &&  //Backspace
          charCode != 92 &&  //backslash
          charCode != 34)    //quote
        return new String.fromCharCode(charCode);
      if (charCode == 92)
        return r"\\";
      if (charCode == 34)
        return '"';
      if (charCode == 8)
        return r"\b";
      if (charCode == 9)
        return r"\t";
      if (charCode == 10)
        return r"\n";
      if (charCode == 12)
        return r"\f";
      if (charCode == 13)
        return r"\r";
      return r"\u{" + charCode.toRadixString(16) + "}";
    }));
  buffer.write('"');
  return buffer.toString();
}

class GirStateError extends StateError {
  GirStateError(String msg) : super(msg);
}