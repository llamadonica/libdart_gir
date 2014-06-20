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

public delegate T? UnmarshallFromDart<T> (Dart.Handle handle, out Dart.Handle? on_error = null) throws Dart.DartError;
public delegate Dart.Handle MarshallToDart<T> (T? value, out Dart.Handle? on_error = null) throws Dart.DartError;

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
  
  Dart.Handle result_code = parent_library.create_native_wrapper_class(new Dart.StringHandle("GTypeDef"),1);
  if (result_code.is_error())
    return result_code;
  
  result_code = 
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
    default: return null;
  }
}

unowned string? name_symbol (Dart.NativeFunction function) {
  debug("Entered name_symbol\n");
  
  if (function == Repository.get_default) return "dart_gir_repository_get_default";
  if (function == Repository.require) return "dart_gir_repository_require";
  return null;
}

public class Unmarshallers {
  public static string @string (Dart.Handle handle, out Dart.Handle? on_error = null) throws Dart.DartError {
    if (handle.is_string() ) {
      string result;
      ((Dart.StringHandle) handle).to_c_string(out result).recast_error(out on_error);
      return result;
    } else if (handle.is_null()) {
      return null;
    } else {
      on_error = null;
      throw new Dart.DartError.UNEXPECTED_CAST("Expected [string] in unmarshaller.");
    }
  }
  public static T[] list<T> (UnmarshallFromDart<T> unmarshaller, Dart.Handle handle, out Dart.Handle? on_error = null) throws Dart.DartError {
    if (handle.is_list()) {
      int length;
      var list_handle = (Dart.ListHandle) handle;
      list_handle.length(out length).recast_error(out on_error);
      var result = new T[length];
      for (var i = 0; i < length; i++) {
        var inner_handle = list_handle[i];
        inner_handle.recast_error(out on_error);
        result[i] = unmarshaller(inner_handle, out on_error);
      }
      return result;
    } else {
      on_error = null;
      throw new Dart.DartError.UNEXPECTED_CAST("Expected [list] in unmarshaller.");
    }
  }
  public static T? nullable<T> (UnmarshallFromDart<T> unmarshaller, Dart.Handle handle, out Dart.Handle? on_error = null) throws Dart.DartError {
    if (handle.is_null())
      return null;
    return unmarshaller(handle, out on_error);
  }
}

public class Marshallers {
  public static Dart.Handle @string (string value, out Dart.Handle? on_error = null) throws Dart.DartError {
    if (value == null)
      return Dart.Handle.null();
    return new Dart.StringHandle(value);
  }
  public static Dart.Handle list<T> (MarshallToDart<T> marshaller, T[] value, out Dart.Handle? on_error = null) throws Dart.DartError {
    var result = new Dart.ListHandle(value.length);
    for (var i = 0; i < value.length; i++) {
      result.set(i, marshaller(value[i], out on_error)).recast_error(out on_error);
    }
    return result;
  }
  public static  Dart.Handle nullable<T> (MarshallToDart<T> marshaller, T? value, out Dart.Handle? on_error = null) throws Dart.DartError {
    if (value == null)
      return Dart.Handle.null();
    return marshaller(value, out on_error);
  }
}

public class Repository {
  public static void get_default (Dart.NativeArguments arg) {
    debug("Entered Repository.get_default\n");
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    cls.rethrow();
    
    
    Dart.Handle result = null;
    Dart.Handle error;
    try {
      unowned GI.Repository repository = GI.Repository.get_default();
      result = Dart.Handle.wrap<unowned GI.Repository>(repository, cls, null, true, out error);
      
      arg.set_return_value(result);
      debug("Exiting Repository.get_default\n");
    } catch (Dart.DartError err) {
      error.rethrow();
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
    try {
      unowned GI.Repository repository = repoProxy.unwrap<unowned GI.Repository> ();
      unowned GI.Typelib typeLib = repository.require (namespace_, version, GI.RepositoryLoadFlags.IREPOSITORY_LOAD_FLAG_LAZY);
      Dart.Handle result = Dart.Handle.wrap<unowned GI.Typelib>(typeLib, typeLibCls, null);
      cls.recast_error();
      arg.set_return_value(result);
    } catch (Dart.DartError err) {
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
    
    Dart.Handle set_on_error;
    
    try {
      string namespace = Unmarshallers.string(namespaceProxy, out set_on_error);
      unowned GI.Repository repository = repoProxy.unwrap<unowned GI.Repository> ();
      string[] dependencies = repository.get_dependencies(namespace);
      var result = Marshallers.list<string>(Marshallers.string, dependencies, out set_on_error);
      arg.set_return_value(result);
    } catch (Dart.DartError err) {
      if (err is Dart.DartError.CATCH)
        set_on_error.rethrow();
      (new Dart.APIErrorHandle(err.message)).rethrow();
    }
  }
}

}