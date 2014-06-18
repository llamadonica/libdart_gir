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

[CCode (cname="dart_gir_Init", type="DART_EXPORT Dart_Handle")]
public Dart.Handle init(Dart.LibraryHandle parent_library) {
  stderr.printf("Entered init\n");
  
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
  stderr.printf("Entered resolve_name\n");
  
  if (!name.is_string()) return null;
  string cname;
  
  ((Dart.StringHandle) name).to_c_string(out cname);
  switch (cname) {
    case "dart_gir_repository_get_default":
      return Repository.get_default;
    case "dart_gir_repository_require":
      return Repository.require;
    default: return null;
  }
}

unowned string? name_symbol (Dart.NativeFunction function) {
  stderr.printf("Entered name_symbol\n");
  
  if (function == Repository.get_default) return "dart_gir_repository_get_default";
  if (function == Repository.require) return "dart_gir_repository_require";
  return null;
}

public class Wrappers {
  public static Dart.Handle from_string_array(string[] names) {
    Dart.ListHandle result = new Dart.ListHandle(names.length);
    for (int i = 0; i < names.length; i++) {
      Dart.StringHandle string = new Dart.StringHandle(names[i]);
      result[i] = string;
    }
    return result;
  }
}

public class Repository {
  public static void get_default (Dart.NativeArguments arg) {
    stderr.printf("Entered Repository.get_default\n");
    Dart.ClassHandle cls = Dart.LibraryHandle.get_root_library().get_class(new Dart.StringHandle("GTypeDef"));
    cls.rethrow();
    
    
    Dart.Handle result = null;
    Dart.Handle error;
    try {
      unowned GI.Repository repository = GI.Repository.get_default();
      result = Dart.Handle.wrap<unowned GI.Repository>(repository, cls, null, true, out error);
      
      arg.set_return_value(result);
      stderr.printf("Exiting Repository.get_default\n");
    } catch (Dart.DartError err) {
      error.rethrow();
    }
  }
  
  public static void require (Dart.NativeArguments arg) {
    stderr.printf("Entered Repository.require\n");
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
}

}