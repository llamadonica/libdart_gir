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

extern int g_constant_info_get_value (GI.ConstantInfo info, out GI.Argument value);
extern void g_constant_info_free_value (GI.ConstantInfo info, GI.Argument value);

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
      return AttributeIter.new_;
    case "dart_gir_base_info_iterate_attributes":
      return BaseInfo.iterate_attributes;
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
  if (function == AttributeIter.new_) return "dart_gir_attribute_iter_new";
  if (function == BaseInfo.iterate_attributes) return "dart_gir_base_info_iterate_attributes";
  return null;
}

[Compact]
public class Unmarshallers {
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
      throw new Dart.DartError.API_ERROR("Expected BaseInfo subtype.");
    }
    
    var gtypedef = handle.get_field(new Dart.StringHandle("_intrinsic"));
    gtypedef.recast_error(ref on_error);
    
    return gtypedef.unwrap<GI.BaseInfo>(ref on_error);
  }
  public static AttributeIter attribute_iter (Dart.Handle handle, ref Dart.Handle? on_error) throws Dart.DartError {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("_AttributeIterator"));
    cls.recast_error(ref on_error);
    
    bool is_base_info;
    handle.is_type(cls, out is_base_info).recast_error(ref on_error);
    
    if (!is_base_info) {
      throw new Dart.DartError.API_ERROR("Expected BaseInfo subtype.");
    }
    
    var gtypedef = handle.get_field(new Dart.StringHandle("_intrinsic"));
    gtypedef.recast_error(ref on_error);
    
    return gtypedef.unwrap<AttributeIter>(ref on_error);
  }
}

[Compact]
public class Marshallers {
  public static Dart.Handle bool (bool value, ref Dart.Handle? on_error) throws Dart.DartError {
    return new Dart.BooleanHandle(value);
  }
  public static Dart.Handle @string (string value, ref Dart.Handle? on_error) throws Dart.DartError {
    return new Dart.StringHandle(value);
  }
  public static Dart.Handle integer_native (int value, ref Dart.Handle? on_error) throws Dart.DartError {
    return new Dart.IntHandle((int64) value);
  }
  public static Dart.Handle list<T> (MarshallToDart<T> marshaller, T[] value, ref Dart.Handle? on_error) throws Dart.DartError {
    var result = new Dart.ListHandle(value.length);
    for (var i = 0; i < value.length; i++) {
      result.set(i, marshaller(value[i], ref on_error)).recast_error(ref on_error);
    }
    return result;
  }
  public static  Dart.Handle nullable<T> (MarshallToDart<T> marshaller, T? value, ref Dart.Handle? on_error) throws Dart.DartError {
    if (value == null)
      return Dart.Handle.null();
    return marshaller(value, ref on_error);
  }
  public static Dart.Handle gi_base_info (GI.BaseInfo value, ref Dart.Handle? on_error) throws Dart.DartError {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    cls.recast_error(ref on_error);
    
    var gtypedef = Dart.Handle.wrap<GI.BaseInfo>(value, cls, null, false, ref on_error);
    string type_name = GI.InfoType.to_string(value.get_type());
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
  public static Dart.Handle attribute_iter(AttributeIter value, ref Dart.Handle? on_error) throws Dart.DartError {
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    cls.recast_error(ref on_error);
    
    var gtypedef = Dart.Handle.wrap<AttributeIter>(value, cls, null, false, ref on_error);
    //string type_name = "AttributeIter";
    
    //cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle(type_name));
    //cls.recast_error(ref on_error);
    
    //var result = cls.new(new Dart.StringHandle("_intrinsic"), {gtypedef});
    //result.recast_error(ref on_error);
    
    return gtypedef;
  }
}

[Compact]
public class Repository {
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
[Compact]
public class BaseInfo {
  public static void get_name (Dart.NativeArguments arg) {
    Dart.Handle infoProxy = arg.get_native_argument(0);
    infoProxy.rethrow();
      
    Dart.Handle? set_on_error = null;
      
    try {
        GI.BaseInfo base_info = Unmarshallers.gi_base_info(infoProxy, ref set_on_error);
        string name = base_info.get_name();
        var result = Marshallers.string(name, ref set_on_error);
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
        AttributeIter iter = Unmarshallers.attribute_iter(iteratorProxy, ref set_on_error);
        
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
[Compact]
[CCode (ref_function="dart_gir_attribute_iter_new_copy", unref_function="dart_gir_attribute_iter_free")]
public class AttributeIter {
  public static void new_ (Dart.NativeArguments arg) {
      
    Dart.Handle? set_on_error = null;
      
    try {
        AttributeIter value = new AttributeIter();
        var result = Marshallers.nullable<AttributeIter>(Marshallers.attribute_iter,new AttributeIter.copy(value), ref set_on_error);
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
  
  public GI.AttributeIter *value;
  public AttributeIter() {
    value = (GI.AttributeIter *) malloc (sizeof(GI.AttributeIter));
    *value = {};
  }
  public AttributeIter.copy(AttributeIter old) {
    value = (GI.AttributeIter *) malloc (sizeof(GI.AttributeIter));
    *value = *old.value;
  }
  ~AttributeIter() {
    free(value);
  }
}

public class ConstantValue {
  private GI.ConstantInfo _constant;
  private GI.Argument _value;
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


}