/* -*- Mode: Vala; indent-tabs-mode: s; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * dart_gir_core.vala
 * Copyright (C) 2014 Adam Stark <llamadonica@gmail.com>
 * 
 * libdart-gir is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * libdart-gir is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace DartGir {

public delegate T? UnmarshallFromDart<T> (Dart.Handle handle, ref Dart.Handle? on_error) throws Dart.DartError;
public delegate Dart.Handle MarshallToDart<T> (T? value, ref Dart.Handle? on_error) throws Dart.DartError;

[ PrintfFormat ] 
public void debug (string format, ...) {
#if DEBUG
  stderr.vprintf (format, va_list());
#endif
} 
[CCode (cname="dart_gir_Init", type="DART_EXPORT Dart_Handle")]
public Dart.Handle init(Dart.LibraryHandle parent_library) {
  debug("Entered init\n");
  
  if (parent_library.is_error())
    return parent_library;
  
  //Dart.Handle result_code = parent_library.create_native_wrapper_class(new Dart.StringHandle("GTypeDef"),1);
  //if (result_code.is_error())
  //  return result_code;
  
  Dart.Handle result_code = 
    parent_library.set_native_resolver(resolve_name,name_symbol);
  if (result_code.is_error())
    return result_code;
    
  return Dart.Handle.null();  
}
Dart.NativeFunction? resolve_name(Dart.Handle name, int argc, out bool auto_setup_scope) {
  debug("Entered resolve_name\n");
  
  if (!name.is_string()) return null;
  string cname;
  
  ((Dart.StringHandle) name).to_c_string(out cname);
  switch (cname) {
    case "dart_gir_repository_get_default":
      return Repository.get_default;
    case "dart_gir_repository_require":
      return Repository.require;
    case "dart_gir_repository_get_dependencies":
      return Repository.get_dependencies;
    case "dart_gir_repository_get_n_infos":
      return Repository.get_n_infos;
    case "dart_gir_repository_get_info":
      return Repository.get_info;
    case "dart_gir_base_info_get_name":
      return BaseInfo.get_name;
    case "dart_gir_base_info_get_attribute":
      return BaseInfo.get_attribute;
    case "dart_gir_attribute_iter_new":
      return AttributeIterator.new_;
    case "dart_gir_base_info_iterate_attributes":
      return BaseInfo.iterate_attributes;
    case "dart_gir_constant_info_get_type":
      return ConstantInfo.get_type;
    case "dart_gir_type_info_get_tag":
      return TypeInfo.get_tag;
    case "dart_gir_type_tag_to_string":
      return TypeTag.to_string;
    case "dart_gir_constant_info_get_value":
      return ConstantInfo.get_value;
    case "dart_gir_struct_info_get_size":
      return StructInfo.get_size;
    case "dart_gir_struct_info_get_n_fields":
      return StructInfo.get_n_fields;
    case "dart_gir_struct_info_get_field":
      return StructInfo.get_field;
    case "dart_gir_field_info_get_size":
      return FieldInfo.get_size;
    case "dart_gir_field_info_get_offset":
      return FieldInfo.get_offset;
    case "dart_gir_field_info_get_type":
      return FieldInfo.get_type;
    case "dart_gir_get_native_int_size":
      return get_native_int_size;
    case "dart_gir_field_info_get_flags":
      return FieldInfo.get_flags;
    case "dart_gir_peek_string_from_buffer":
      return peek_string_from_buffer;
    case "dart_gir_poke_string_to_buffer":
      return poke_string_to_buffer;
    case "dart_gir_type_info_get_array_type":
      return TypeInfo.get_array_type;
    case "dart_gir_type_info_get_param_type":
      return TypeInfo.get_param_type;
    case "dart_gir_type_info_get_array_fixed_size":
      return TypeInfo.get_array_fixed_size;
    case "dart_gir_type_info_get_interface":
      return TypeInfo.get_interface;
    case "dart_gir_enum_info_get_n_values":
      return EnumInfo.get_n_values;
    case "dart_gir_enum_info_get_value":
      return EnumInfo.get_value;
    case "dart_gir_enum_info_get_storage_type":
      return EnumInfo.get_storage_type;
    case "dart_gir_value_info_get_value":
      return ValueInfo.get_value;
      
    default: return null;
  }
}
unowned string? name_symbol (Dart.NativeFunction function) {
  debug("Entered name_symbol\n");
  
  if (function == Repository.get_default) return "dart_gir_repository_get_default";
  if (function == Repository.require) return "dart_gir_repository_require";
  if (function == Repository.get_dependencies) return "dart_gir_repository_get_dependencies";
  if (function == Repository.get_n_infos) return "dart_gir_repository_get_n_infos";
  if (function == Repository.get_info) return "dart_gir_repository_get_info";
  if (function == BaseInfo.get_name) return "dart_gir_base_info_get_name";
  if (function == BaseInfo.get_attribute) return "dart_gir_base_info_get_attribute";
  if (function == AttributeIterator.new_) return "dart_gir_attribute_iter_new";
  if (function == BaseInfo.iterate_attributes) return "dart_gir_base_info_iterate_attributes";
  if (function == ConstantInfo.get_type) return "dart_gir_constant_info_get_type";
  if (function == TypeInfo.get_tag) return "dart_gir_type_info_get_tag";
  if (function == TypeTag.to_string) return "dart_gir_type_tag_to_string";
  if (function == ConstantInfo.get_value) return "dart_gir_constant_info_get_value";
  if (function == StructInfo.get_size) return "dart_gir_struct_info_get_size";
  if (function == StructInfo.get_n_fields) return "dart_gir_struct_info_get_n_fields";
  if (function == StructInfo.get_field) return "dart_gir_struct_info_get_field";
  if (function == FieldInfo.get_size) return "dart_gir_field_info_get_size";
  if (function == FieldInfo.get_offset) return "dart_gir_field_info_get_offset";
  if (function == FieldInfo.get_type) return "dart_gir_field_info_get_type";
  if (function == get_native_int_size) return "dart_gir_get_native_int_size";
  if (function == FieldInfo.get_flags) return "dart_gir_field_info_get_flags"; 
  return null;
}

public static void get_native_int_size (Dart.NativeArguments arg) {
  debug("Entered get_native_int_size\n");
  
  Dart.Handle? set_on_error = null;
    
  try {
    var result = Marshallers.unsigned_integer64((uint64) sizeof(int), ref set_on_error);
    arg.set_return_value(result);
  } catch (Dart.DartError err) {
    if (err is Dart.DartError.CATCH && set_on_error != null) {
      set_on_error.rethrow();
    } else if (err is Dart.DartError.CATCH) {
      assert_not_reached();
    }
    (new Dart.APIErrorHandle(err.message)).rethrow();
  } 
}
public static void peek_string_from_buffer (Dart.NativeArguments arg) {
  debug("Entered peek_string_from_buffer\n");

  Dart.Handle? set_on_error = null;
  
  Dart.Handle bufferEntity = arg.get_native_argument(0);
  bufferEntity.rethrow();
  
  Dart.Handle offsetProxy = arg.get_native_argument(1);
  offsetProxy.rethrow();
  
  try {
    var tempByteData = bufferEntity.invoke(new Dart.StringHandle("asByteData"), 
        {offsetProxy, Marshallers.unsigned_integer64((uint64) sizeof(void*), ref set_on_error)});
    void* data;
    Dart.TypedDataType type;
    int length;
    string output;
    tempByteData.acquire_data(out type, out data, out length).recast_error(ref set_on_error);
    
    try {
      output = ((string[]) data)[0];
    } catch (Dart.DartError err) {
      throw err;
    } finally {
      tempByteData.release_data();
    }
    
    var result = new Dart.StringHandle(output);
    arg.set_return_value(result);
  }catch (Dart.DartError err) {
    if (err is Dart.DartError.CATCH && set_on_error != null) {
      set_on_error.rethrow();
    } else if (err is Dart.DartError.CATCH) {
      assert_not_reached();
    }
    (new Dart.APIErrorHandle(err.message)).rethrow();
  }
}
public static void poke_string_to_buffer (Dart.NativeArguments arg) {
  debug("Entered poke_string_to_buffer\n");

  Dart.Handle? set_on_error = null;
  
  Dart.Handle bufferEntity = arg.get_native_argument(0);
  bufferEntity.rethrow();
  
  Dart.Handle offsetProxy = arg.get_native_argument(1);
  offsetProxy.rethrow();
  
  Dart.Handle stringProxy = arg.get_native_argument(1);
  stringProxy.rethrow();
  
  try {
    var tempByteData = bufferEntity.invoke(new Dart.StringHandle("asByteData"), 
        {offsetProxy, Marshallers.unsigned_integer64((uint64) sizeof(void*), ref set_on_error)});
    void* data;
    Dart.TypedDataType type;
    int length;
    
    string* input = Unmarshallers.string(stringProxy, ref set_on_error);
    tempByteData.acquire_data(out type, out data, out length).recast_error(ref set_on_error);
    
    try {
      ((string[]) data)[0] = input;
    } catch (Dart.DartError err) {
      throw err;
    } finally {
      tempByteData.release_data();
    }
    
    arg.set_return_value(Dart.Handle.null());
  }catch (Dart.DartError err) {
    if (err is Dart.DartError.CATCH && set_on_error != null) {
      set_on_error.rethrow();
    } else if (err is Dart.DartError.CATCH) {
      assert_not_reached();
    }
    (new Dart.APIErrorHandle(err.message)).rethrow();
  }
}

namespace Unmarshallers {
  public static int integer_native (Dart.Handle handle, ref Dart.Handle? on_error) throws Dart.DartError {
    if (handle.is_int() ) {
      int64 result;
      ((Dart.IntHandle) handle).to_int64(out result).recast_error(ref on_error);
      if (sizeof(int64) > sizeof(int) && (result > (int64) int.MAX || result < (int64) int.MIN)) 
        throw new Dart.DartError.UNEXPECTED_CAST("Expected [int] in unmarshaller but data would not fit in int.");
      return (int) result;
    } else {
      on_error = null;
      throw new Dart.DartError.UNEXPECTED_CAST("Expected [int] in unmarshaller.");
    }
  }
  public static string @string (Dart.Handle handle, ref Dart.Handle? on_error) throws Dart.DartError {
    if (handle.is_string() ) {
      string result;
      ((Dart.StringHandle) handle).to_c_string(out result).recast_error(ref on_error);
      return result;
    } else {
      on_error = null;
      throw new Dart.DartError.UNEXPECTED_CAST("Expected [String] in unmarshaller.");
    }
  }
  public static T[] list<T> (UnmarshallFromDart<T> unmarshaller, Dart.Handle handle, ref Dart.Handle? on_error) throws Dart.DartError {
    if (handle.is_list()) {
      int length;
      var list_handle = (Dart.ListHandle) handle;
      list_handle.length(out length).recast_error(ref on_error);
      var result = new T[length];
      for (var i = 0; i < length; i++) {
        var inner_handle = list_handle[i];
        inner_handle.recast_error(ref on_error);
        result[i] = unmarshaller(inner_handle, ref on_error);
      }
      return result;
    } else {
      on_error = null;
      throw new Dart.DartError.UNEXPECTED_CAST("Expected [List] in unmarshaller.");
    }
  }
  public static T? nullable<T> (UnmarshallFromDart<T> unmarshaller, Dart.Handle handle, ref Dart.Handle? on_error) throws Dart.DartError {
    if (handle.is_null())
      return null;
    return unmarshaller(handle, ref on_error);
  }
  public static GI.BaseInfo gi_base_info (Dart.Handle handle, ref Dart.Handle? on_error) throws Dart.DartError {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("BaseInfo"));
    cls.recast_error(ref on_error);
    
    bool is_base_info;
    handle.is_type(cls, out is_base_info).recast_error(ref on_error);
    
    if (!is_base_info) {
      Dart.Handle inner_error = null;
      string output;
      try {
        var handle_type = handle.get_type();
        handle_type.recast_error(ref inner_error);
      
        var type_name = handle_type.to_string();
        type_name.recast_error(ref inner_error);
        
        type_name.to_c_string(out output).recast_error(ref on_error);
      } catch {
        output = "***unknown type***";
      }
      
      throw new Dart.DartError.API_ERROR("Expected [BaseInfo] subtype but found [%s].", output);
    }
    
    var gtypedef = handle.get_field(new Dart.StringHandle("_intrinsic"));
    gtypedef.recast_error(ref on_error);
    
    return gtypedef.unwrap<GI.BaseInfo>(ref on_error);
  }
  public static GI.AttributeIterator attribute_iter (Dart.Handle handle, ref Dart.Handle? on_error) throws Dart.DartError {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("_AttributeIterator"));
    cls.recast_error(ref on_error);
    
    bool is_base_info;
    handle.is_type(cls, out is_base_info).recast_error(ref on_error);
    
    if (!is_base_info) {
      throw new Dart.DartError.API_ERROR("Expected BaseInfo subtype.");
    }
    
    var gtypedef = handle.get_field(new Dart.StringHandle("_intrinsic"));
    gtypedef.recast_error(ref on_error);
    
    return gtypedef.unwrap<GI.AttributeIterator>(ref on_error);
  }
}
namespace Marshallers {
  public static Dart.Handle bool (bool value, ref Dart.Handle? on_error) throws Dart.DartError {
    return new Dart.BooleanHandle(value);
  }
  public static Dart.Handle @string (string value, ref Dart.Handle? on_error) throws Dart.DartError {
    return new Dart.StringHandle(value);
  }
  public static Dart.Handle integer_native (int value, ref Dart.Handle? on_error) throws Dart.DartError {
    return new Dart.IntHandle((int64) value);
  }
  public static Dart.Handle integer64 (int64 value, ref Dart.Handle? on_error) throws Dart.DartError {
    return new Dart.IntHandle(value);
  }
  public static Dart.Handle unsigned_integer64 (uint64 value, ref Dart.Handle? on_error) throws Dart.DartError {
    var str = value.to_string("0x%" + uint64.FORMAT_MODIFIER + "X");
    var x = new Dart.IntHandle.from_hex_c_string(str);
    x.recast_error(ref on_error);
    return x;
  }
  public static Dart.Handle double (double value, ref Dart.Handle? on_error) throws Dart.DartError {
    return new Dart.DoubleHandle(value);
  }
  public static Dart.Handle list<T> (MarshallToDart<T> marshaller, T[] value, ref Dart.Handle? on_error) throws Dart.DartError {
    var result = new Dart.ListHandle(value.length);
    for (var i = 0; i < value.length; i++) {
      result.set(i, marshaller(value[i], ref on_error)).recast_error(ref on_error);
    }
    return result;
  }
  public static Dart.Handle nullable<T> (MarshallToDart<T> marshaller, T? value, ref Dart.Handle? on_error) throws Dart.DartError {
    if (value == null)
      return Dart.Handle.null();
    return marshaller(value, ref on_error);
  }
  public static Dart.Handle gi_base_info (GI.BaseInfo value, ref Dart.Handle? on_error) throws Dart.DartError {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    cls.recast_error(ref on_error);
    
    var gtypedef = Dart.Handle.wrap<GI.BaseInfo>(value, cls, null, false, ref on_error);
    string type_name = value.get_type().to_string();
    StringBuilder type_name_builder = new StringBuilder(type_name);
    type_name_builder.append("Info");
    type_name_builder.overwrite(0,type_name.get_char().toupper().to_string());
    //type_name_builder.prepend("_");
    
    cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle(type_name_builder.str));
    cls.recast_error(ref on_error);
    
    var result = cls.new(new Dart.StringHandle("_intrinsic"), {gtypedef});
    result.recast_error(ref on_error);
    
    return result;
  }
  public static Dart.Handle attribute_iter(GI.AttributeIterator value, ref Dart.Handle? on_error) throws Dart.DartError {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    cls.recast_error(ref on_error);
    
    var gtypedef = Dart.Handle.wrap<GI.AttributeIterator>(value, cls, null, false, ref on_error);
    //string type_name = "AttributeIter";
    
    //cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle(type_name));
    //cls.recast_error(ref on_error);
    
    //var result = cls.new(new Dart.StringHandle("_intrinsic"), {gtypedef});
    //result.recast_error(ref on_error);
    
    return gtypedef;
  }
  public static Dart.Handle type_tag(GI.TypeTag value, ref Dart.Handle? on_error) throws Dart.DartError {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("TypeTag"));
    cls.recast_error(ref on_error);
    debug("Creating a new TypeTag.\n");
    var result = cls.new(Dart.Handle.null(), {integer_native(value, ref on_error)} );
    
    return result;
  }
  public static Dart.Handle constant_value_variant(GI.ConstantValue value, ref Dart.Handle? on_error) throws Dart.DartError {
    
    int64 int_value = 0;
    uint64 uint_value = 0;
    double double_value = 0;
    bool bool_value = false;
    string? string_value = null;
    var _tag = value.type_.tag;
    
    switch (_tag) {
      case GI.TypeTag.BOOLEAN:
        bool_value = value.value.v_boolean;
        break;
      case GI.TypeTag.INT8:
        int_value = (int64) value.value.v_int8;
        break;
      case GI.TypeTag.UINT8:
        int_value = (int64) value.value.v_uint8;
        break;
      case GI.TypeTag.INT16:
        int_value = (int64) value.value.v_int16;
        break;
      case GI.TypeTag.UINT16:
        int_value = (int64) value.value.v_uint16;
        break;
      case GI.TypeTag.INT32:
        int_value = (int64) value.value.v_int32;
        break;
      case GI.TypeTag.UINT32:
        int_value = (int64) value.value.v_uint32;
        break;
      case GI.TypeTag.INT64:
        int_value = value.value.v_int64;
        break;
      case GI.TypeTag.UINT64:
        uint_value = value.value.v_uint64;
        break;
      case GI.TypeTag.FLOAT:
        double_value = (double) value.value.v_float;
        break;
      case GI.TypeTag.DOUBLE:
        double_value = value.value.v_double;
        break;
      case GI.TypeTag.UTF8:
      case GI.TypeTag.FILENAME:
        string_value = value.value.v_string;
        break;
      case GI.TypeTag.ARRAY:
      case GI.TypeTag.INTERFACE:
      case GI.TypeTag.GLIST:
      case GI.TypeTag.GSLIST:
      case GI.TypeTag.GHASH:
      case GI.TypeTag.ERROR:
      case GI.TypeTag.UNICHAR:
      case GI.TypeTag.VOID:
      case GI.TypeTag.GTYPE:
        throw new Dart.DartError.UNEXPECTED_CAST(
          @"Expected some const variant in marshaller, but got $(value.type_.tag)");
    }
    switch (_tag) {
      case GI.TypeTag.BOOLEAN:
        return bool(bool_value, ref on_error);
    
      case GI.TypeTag.INT8:
      case GI.TypeTag.UINT8:
      case GI.TypeTag.INT16:
      case GI.TypeTag.UINT16:
      case GI.TypeTag.INT32:
      case GI.TypeTag.UINT32:
      case GI.TypeTag.INT64:
        return integer64(int_value, ref on_error);
        
      case GI.TypeTag.UINT64:
         return unsigned_integer64(uint_value, ref on_error);
        
      case GI.TypeTag.FLOAT:
      case GI.TypeTag.DOUBLE:
        return double(double_value, ref on_error);
      
      case GI.TypeTag.UTF8:
      case GI.TypeTag.FILENAME:
        return string(string_value, ref on_error);
      
      case GI.TypeTag.ARRAY:
      case GI.TypeTag.INTERFACE:
      case GI.TypeTag.GLIST:
      case GI.TypeTag.GSLIST:
      case GI.TypeTag.GHASH:
      case GI.TypeTag.ERROR:
      case GI.TypeTag.UNICHAR:
      case GI.TypeTag.VOID:
      case GI.TypeTag.GTYPE:
      default:
        assert_not_reached();
    }
  }
  public static Dart.Handle field_info_flags(GI.FieldInfoFlags value, ref Dart.Handle? on_error) throws Dart.DartError {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("FieldInfoFlags"));
    cls.recast_error(ref on_error);
    debug("Creating a new TypeTag.\n");
    var result = cls.new(Dart.Handle.null(), {integer_native(value, ref on_error)} );
    
    return result;
  }
  public static Dart.Handle array_type(GI.ArrayType value, ref Dart.Handle? on_error) throws Dart.DartError {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("ArrayType"));
    cls.recast_error(ref on_error);
    debug("Creating a new TypeTag.\n");
    var result = cls.new(Dart.Handle.null(), {integer_native(value, ref on_error)} );
    
    return result;
  }

}
namespace Repository {
  public static void get_default (Dart.NativeArguments arg) {
    debug("Entered Repository.get_default\n");
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    cls.rethrow();
    
    
    Dart.Handle result = null;
    Dart.Handle error = null;
    try {
      unowned GI.Repository repository = GI.Repository.get_default();
      result = Dart.Handle.wrap<unowned GI.Repository>(repository, cls, null, true, ref error);
      
      arg.set_return_value(result);
      debug("Exiting Repository.get_default\n");
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && error != null) {
        error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  
  public static void require (Dart.NativeArguments arg) {
    debug("Entered Repository.require\n");
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    cls.rethrow();
    
    Dart.ClassHandle typeLibCls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    typeLibCls.rethrow();
    
    Dart.Handle repoProxy = arg.get_native_argument(0);
    repoProxy.rethrow();
    
    Dart.Handle namespaceProxy = arg.get_native_argument(1);
    namespaceProxy.rethrow();
    
    Dart.Handle versionProxy = arg.get_native_argument(2);
    versionProxy.rethrow();
    
    string namespace_ = null;
    if (namespaceProxy.is_string()) {
      ((Dart.StringHandle) namespaceProxy).to_c_string(out namespace_).rethrow();
    } else {
      (new Dart.APIErrorHandle("Expected String.")).rethrow();
    }
    
    string? version = null;
    if (versionProxy.is_string()) {
      ((Dart.StringHandle) versionProxy).to_c_string(out version).rethrow();
    } else if (versionProxy.is_null()) {
      version = null;
    } else {
      (new Dart.APIErrorHandle("Expected String or null.")).rethrow();
    }
    
    bool is_repository;
    repoProxy.is_type(cls, out is_repository).rethrow();
    if (!is_repository) {
      (new Dart.APIErrorHandle("Expected Repository.")).rethrow();
    }
    
    Dart.Handle? set_on_error = null;
    
    try {
      unowned GI.Repository repository = repoProxy.unwrap<unowned GI.Repository> (ref set_on_error);
      unowned GI.Typelib typeLib = repository.require (namespace_, version, GI.RepositoryLoadFlags.IREPOSITORY_LOAD_FLAG_LAZY);
      Dart.Handle result = Dart.Handle.wrap<unowned GI.Typelib>(typeLib, typeLibCls, null, false, ref set_on_error);
      cls.recast_error(ref set_on_error);
      arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    } catch (Error err) {
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  
  public static void get_dependencies (Dart.NativeArguments arg) {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    cls.rethrow();
    
    Dart.ClassHandle typeLibCls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    typeLibCls.rethrow();
    
    Dart.Handle repoProxy = arg.get_native_argument(0);
    repoProxy.rethrow();
    
    Dart.Handle namespaceProxy = arg.get_native_argument(1);
    namespaceProxy.rethrow();
    
    bool is_repository;
    repoProxy.is_type(cls, out is_repository).rethrow();
    if (!is_repository) {
      (new Dart.APIErrorHandle("Expected Repository.")).rethrow();
    }
    
    Dart.Handle? set_on_error = null;
    
    try {
      string namespace = Unmarshallers.string(namespaceProxy, ref set_on_error);
      unowned GI.Repository repository = repoProxy.unwrap<unowned GI.Repository> (ref set_on_error);
      string[] dependencies = repository.get_dependencies(namespace);
      var result = Marshallers.list<string>(Marshallers.string, dependencies, ref set_on_error);
      arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  
  public static void get_n_infos (Dart.NativeArguments arg) {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    cls.rethrow();
    
    Dart.Handle repoProxy = arg.get_native_argument(0);
    repoProxy.rethrow();
    
    Dart.Handle namespaceProxy = arg.get_native_argument(1);
    namespaceProxy.rethrow();
    
    bool is_repository;
    repoProxy.is_type(cls, out is_repository).rethrow();
    
    if (!is_repository) {
      (new Dart.APIErrorHandle("Expected Repository.")).rethrow();
    }
    
    Dart.Handle? set_on_error = null;
    
    try {
      string namespace = Unmarshallers.string(namespaceProxy, ref set_on_error);
      unowned GI.Repository repository = repoProxy.unwrap<unowned GI.Repository> (ref set_on_error);
      var n_infos = repository.get_n_infos(namespace);
      var result = Marshallers.integer_native(n_infos, ref set_on_error);
      arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  
  public static void get_info (Dart.NativeArguments arg) {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    cls.rethrow();
    
    Dart.Handle repoProxy = arg.get_native_argument(0);
    repoProxy.rethrow();
    
    Dart.Handle namespaceProxy = arg.get_native_argument(1);
    namespaceProxy.rethrow();
    
    Dart.Handle indexProxy = arg.get_native_argument(2);
    indexProxy.rethrow();
    
    bool is_repository;
    repoProxy.is_type(cls, out is_repository).rethrow();
    
    if (!is_repository) {
      (new Dart.APIErrorHandle("Expected Repository.")).rethrow();
    }
    
    Dart.Handle? set_on_error = null;
    
    try {
      string namespace = Unmarshallers.string(namespaceProxy, ref set_on_error);
      int index = Unmarshallers.integer_native(indexProxy, ref set_on_error);
      unowned GI.Repository repository = repoProxy.unwrap<unowned GI.Repository> (ref set_on_error);
      
      var info = repository.get_info(namespace,index);
      
      var result = Marshallers.gi_base_info(info, ref set_on_error);
      
      arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
}
namespace BaseInfo {
  public static void get_name (Dart.NativeArguments arg) {
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
      
    Dart.Handle? set_on_error = null;
      
    try {
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        var result = Marshallers.string(base_info.name, ref set_on_error);
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void get_attribute (Dart.NativeArguments arg) {
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle attributeProxy = arg.get_native_argument(1);
    attributeProxy.rethrow();

    Dart.Handle? set_on_error = null;
      
    try {
      GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
      string attribute = Unmarshallers.string(attributeProxy, ref set_on_error);
      string? value = base_info.get_attribute(attribute).dup();
      var result = Marshallers.nullable<string>(Marshallers.string, value, ref set_on_error);
      arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void iterate_attributes (Dart.NativeArguments arg) {
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle iteratorProxy = arg.get_native_argument(1);
    iteratorProxy.rethrow();
      
    Dart.Handle? set_on_error = null;
      
    try {
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        GI.AttributeIterator iter = Unmarshallers.attribute_iter(iteratorProxy, ref set_on_error);
        
        string attribute_name, value_name;
        GI.AttributeIter iter_value = *iter.value;
        
        var value = base_info.iterate_attributes(ref iter_value, out attribute_name, out value_name);
        *iter.value = iter_value;
        
        if (value) {
          iteratorProxy.set_field(new Dart.StringHandle("_attribute"),Marshallers.string(attribute_name, ref set_on_error));
          iteratorProxy.set_field(new Dart.StringHandle("_value"),Marshallers.string(attribute_name, ref set_on_error));
        } else {
          iteratorProxy.set_field(new Dart.StringHandle("_attribute"),Dart.Handle.null());
          iteratorProxy.set_field(new Dart.StringHandle("_value"),Dart.Handle.null());
        }
        
        var result = Marshallers.bool(value, ref set_on_error);
        
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
}
namespace AttributeIterator {
  public static void new_ (Dart.NativeArguments arg) {
    Dart.Handle? set_on_error = null;

    try {
        GI.AttributeIterator value = new GI.AttributeIterator();
        var result = Marshallers.nullable<GI.AttributeIterator>(Marshallers.attribute_iter,value, ref set_on_error);
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
}
namespace TypeInfo {
  public static void get_tag (Dart.NativeArguments arg) {
    debug("Entered TypeInfo.get_tag\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
      
    Dart.Handle? set_on_error = null;
      
    try {
        debug("Trying to get base_info\n");
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        debug("Got base_info\n");
        if (base_info == null || base_info.get_type() != GI.InfoType.TYPE)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.TypeInfo] in unmarshaller.");
        
        var value = ((GI.TypeInfo) base_info).tag;
        var result = Marshallers.type_tag(value, ref set_on_error);
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void get_array_type (Dart.NativeArguments arg) {
    debug("Entered TypeInfo.get_tag\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
      
    Dart.Handle? set_on_error = null;
      
    try {
        debug("Trying to get base_info\n");
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        debug("Got base_info\n");
        if (base_info == null || base_info.get_type() != GI.InfoType.TYPE)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.TypeInfo] in unmarshaller.");
        
        var value = ((GI.TypeInfo) base_info).array_type;
        var result = Marshallers.array_type(value, ref set_on_error);
        result.recast_error(ref set_on_error);
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void get_param_type (Dart.NativeArguments arg) {
    debug("Entered TypeInfo.get_tag\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle paramProxy = arg.get_native_argument(1);
    paramProxy.rethrow();
      
    Dart.Handle? set_on_error = null;
      
    try {
        debug("Trying to get base_info\n");
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        if (base_info == null || base_info.get_type() != GI.InfoType.TYPE)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.TypeInfo] in unmarshaller.");
          
        int param = Unmarshallers.integer_native(paramProxy, ref set_on_error);
        
        debug("Got base_info\n");
        
        var value = ((GI.TypeInfo) base_info).get_param_type(param);
        var result = Marshallers.gi_base_info(value, ref set_on_error);
        result.recast_error(ref set_on_error);
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void get_array_fixed_size (Dart.NativeArguments arg) {
    debug("Entered TypeInfo.get_tag\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle? set_on_error = null;
      
    try {
        debug("Trying to get base_info\n");
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        if (base_info == null || base_info.get_type() != GI.InfoType.TYPE)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.TypeInfo] in unmarshaller.");
          
        var value = ((GI.TypeInfo) base_info).array_fixed_size;
        var result = Marshallers.integer_native(value, ref set_on_error);
        result.recast_error(ref set_on_error);
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void get_interface (Dart.NativeArguments arg) {
    debug("Entered TypeInfo.get_tag\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle? set_on_error = null;
      
    try {
        debug("Trying to get base_info\n");
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        if (base_info == null || base_info.get_type() != GI.InfoType.TYPE)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.TypeInfo] in unmarshaller.");
        
        debug("Got base_info\n");
        
        var value = ((GI.TypeInfo) base_info).interface;
        var result = Marshallers.gi_base_info(value, ref set_on_error);
        result.recast_error(ref set_on_error);
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
}
namespace ConstantInfo {
  public static void get_type (Dart.NativeArguments arg) {
    debug("Entered ConstantInfo.get_type\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle? set_on_error = null;
      
    try {
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        if (base_info == null || base_info.get_type() != GI.InfoType.CONSTANT)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.ConstantInfo] in unmarshaller.");
        
        var value = ((GI.ConstantInfo) base_info).get_type();
        var result = Marshallers.gi_base_info(value, ref set_on_error);
        
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void get_value (Dart.NativeArguments arg) {
    debug("Entered ConstantInfo.get_type\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle? set_on_error = null;
    
    try {
      GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
      if (base_info == null || base_info.get_type() != GI.InfoType.CONSTANT)
        throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.ConstantInfo] in unmarshaller.");
      arg.set_return_value(
        Marshallers.constant_value_variant(
          new GI.ConstantValue((GI.ConstantInfo) base_info), ref set_on_error));
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
}
namespace TypeTag {
  public static void to_string (Dart.NativeArguments arg) {
    debug("Entered TypeTag.to_string\n");
    Dart.Handle tagProxy = arg.get_native_argument(0);
    tagProxy.rethrow();

    Dart.Handle? set_on_error = null;
      
    try {
      var field = tagProxy.get_field(new Dart.StringHandle("_code"));
      field.recast_error(ref set_on_error);
      var tag = (GI.TypeTag) Unmarshallers.integer_native(field, ref set_on_error);
      var result = Marshallers.string(tag.to_string(), ref set_on_error);
      arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
}
namespace StructInfo {
  public static void get_size (Dart.NativeArguments arg) {
    debug("Entered StructInfo.get_size\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle? set_on_error = null;
      
    try {
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        if (base_info == null || base_info.get_type() != GI.InfoType.STRUCT)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.StructInfo] in unmarshaller.");
        
        var value = ((GI.StructInfo) base_info).size;
        var result = Marshallers.unsigned_integer64((uint64) value, ref set_on_error);
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void get_n_fields (Dart.NativeArguments arg) {
    debug("Entered StructInfo.get_size\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle? set_on_error = null;
      
    try {
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        if (base_info == null || base_info.get_type() != GI.InfoType.STRUCT)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.StructInfo] in unmarshaller.");
        
        var value = ((GI.StructInfo) base_info).n_fields;
        var result = Marshallers.integer_native( value, ref set_on_error);
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void get_field (Dart.NativeArguments arg) {
    debug("Entered StructInfo.get_size\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle nProxy = arg.get_native_argument(1);
    nProxy.rethrow();
    
    Dart.Handle? set_on_error = null;
      
    try {
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        var n = Unmarshallers.integer_native(nProxy, ref set_on_error);
        if (base_info == null || base_info.get_type() != GI.InfoType.STRUCT)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.StructInfo] in unmarshaller.");
        
        var value = ((GI.StructInfo) base_info).get_field(n);
        var result = Marshallers.gi_base_info( value, ref set_on_error);
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
}
namespace FieldInfo {
  public static void get_size (Dart.NativeArguments arg) {
    debug("Entered FieldInfo.get_size\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle? set_on_error = null;
      
    try {
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        if (base_info == null || base_info.get_type() != GI.InfoType.FIELD)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.FieldInfo] in unmarshaller.");
        
        var value = ((GI.FieldInfo) base_info).size;
        var result = Marshallers.unsigned_integer64((uint64) value, ref set_on_error);
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    } 
  }
  public static void get_offset (Dart.NativeArguments arg) {
    debug("Entered FieldInfo.get_offset\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle? set_on_error = null;
      
    try {
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        if (base_info == null || base_info.get_type() != GI.InfoType.FIELD)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.FieldInfo] in unmarshaller.");
        
        var value = ((GI.FieldInfo) base_info).offset;
        var result = Marshallers.unsigned_integer64((uint64) value, ref set_on_error);
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void get_type (Dart.NativeArguments arg) {
    debug("Entered ConstantInfo.get_type\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle? set_on_error = null;
      
    try {
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        if (base_info == null || base_info.get_type() != GI.InfoType.FIELD)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.FieldInfo] in unmarshaller.");
        
        var value = ((GI.FieldInfo) base_info).get_type();
        var result = Marshallers.gi_base_info(value, ref set_on_error);
        
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void get_flags (Dart.NativeArguments arg) {
    debug("Entered ConstantInfo.get_type\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
    
    Dart.Handle? set_on_error = null;
      
    try {
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        if (base_info == null || base_info.get_type() != GI.InfoType.FIELD)
          throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.FieldInfo] in unmarshaller.");
        
        var value = ((GI.FieldInfo) base_info).flags;
        var result = Marshallers.field_info_flags(value, ref set_on_error);
        
        arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
}
namespace EnumInfo {
  public static void get_n_values (Dart.NativeArguments arg) {
    debug("Entered EnumInfo.get_n_values\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();

    Dart.Handle? set_on_error = null;

    try {
      GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
      if (base_info == null || base_info.get_type() != GI.InfoType.ENUM)
        throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.EmumInfo] in unmarshaller.");
  
      var value = ((GI.EnumInfo) base_info).n_values;
      var result = Marshallers.unsigned_integer64((uint64) value, ref set_on_error);
      arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void get_storage_type (Dart.NativeArguments arg) {
    debug("Entered EnumInfo.get_storage_type\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();

    Dart.Handle? set_on_error = null;

    try {
      GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
      if (base_info == null || base_info.get_type() != GI.InfoType.ENUM)
        throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.EmumInfo] in unmarshaller.");
  
      var value = ((GI.EnumInfo) base_info).storage_type;
      var result = Marshallers.type_tag(value, ref set_on_error);
      arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
  public static void get_value (Dart.NativeArguments arg) {
    debug("Entered EnumInfo.get_value\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();

    Dart.Handle nProxy = arg.get_native_argument(1);
    nProxy.rethrow();
    Dart.Handle? set_on_error = null;

    try {
      GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
      var n = Unmarshallers.integer_native(nProxy, ref set_on_error);
      if (base_info == null || base_info.get_type() != GI.InfoType.ENUM)
        throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.EmumInfo] in unmarshaller.");

      var value = ((GI.EnumInfo) base_info).get_value(n);
      var result = Marshallers.gi_base_info(value, ref set_on_error);
      arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
}
namespace ValueInfo {
  public static void get_value (Dart.NativeArguments arg) {
    debug("Entered ValueInfo.get_value\n");
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();

    Dart.Handle? set_on_error = null;

    try {
      GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
      if (base_info == null || base_info.get_type() != GI.InfoType.VALUE)
        throw new Dart.DartError.UNEXPECTED_CAST("Expected [GI.ValueInfo] in unmarshaller.");
  
      var value = ((GI.ValueInfo) base_info).value;
      var result = Marshallers.unsigned_integer64((uint64) value, ref set_on_error);
      arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH && set_on_error != null) {
        set_on_error.rethrow();
      } else if (err is Dart.DartError.CATCH) {
        assert_not_reached();
      }
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
}
 
}

extern int g_constant_info_get_value (GI.ConstantInfo info, out GI.Argument value);
extern void g_constant_info_free_value (GI.ConstantInfo info, GI.Argument value);

[CCode (cheader_filename="gi_compat.h")]
namespace GI {

public class ConstantValue {
  private GI.ConstantInfo _constant;
  private GI.Argument _value;
  private GI.TypeInfo? _type;
  
  /***
   * Get the type. Only const types can be handled natively.
   * 
   * Thoughts:
   *   a := [String] | [int] | [double] | [List<a>]
   */
  public GI.TypeInfo type_ {
    get {
      if (_type == null)
        _type = _constant.get_type();
      return _type;
    }
  }
  public GI.ConstantInfo constant {
    get {
      return _constant;
    }
  }
  public GI.Argument value {
    get {
      return _value;
    }
  }
  
  public ConstantValue(GI.ConstantInfo constant) {
    g_constant_info_get_value(constant, out _value);
    _constant = constant;
  }
  ~ConstantValue() {
    g_constant_info_free_value(_constant, _value);
  }
}
[Compact]
[CCode (ref_function="g_attribute_iterator_new_copy", unref_function="g_attribute_iterator_free")]
public class AttributeIterator {
  public GI.AttributeIter *value;
  public AttributeIterator() {
    value = (GI.AttributeIter *) malloc (sizeof(GI.AttributeIter));
    *value = {};
  }
  public AttributeIterator.copy(AttributeIterator old) {
    value = (GI.AttributeIter *) malloc (sizeof(GI.AttributeIter));
    *value = *old.value;
  }
  ~AttributeIterator() {
    free(value);
  }
}

}
