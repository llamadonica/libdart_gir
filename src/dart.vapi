[CCode (cheader_filename="dart_api.h", cprefix="Dart_", lowercase_cprefix="Dart_")]
namespace Dart {
  
[CCode (has_target = false)]
public delegate void NativeFunction(NativeArguments arguments);

[CCode (has_target = false)]
public delegate unowned string? NativeEntrySymbol(NativeFunction function);

[CCode (has_target = false, type="Blah")]
public delegate NativeFunction? NativeEntryResolver(Handle name,  int number_of_arguments, out bool auto_setup_scope);

[Compact]
[CCode (cname="struct _Dart_NativeArguments")]
public class NativeArguments {
  [CCode (cname="Dart_SetReturnValue")]
  public void set_return_value(Handle handle);
  
  [CCode (cname="Dart_GetNativeArgument")]
  public Handle get_native_argument(int index);
}

[Compact]
[CCode (ref_function="dart_handle_ref", unref_function="dart_handle_unref", cname="struct _Dart_Handle", cheader_filename="dart_compat.h", has_type_id=false)]
public class Handle {
  [CCode (cname="Dart_IsError")]
  public bool is_error();
  
  [CCode (cname="Dart_IsString")]
  public bool is_string();
  
  [CCode (cname="Dart_IsNull")]
  public bool is_null();
  
  [CCode (cname="Dart_IsList")]
  public bool is_list();
  
  [CCode (cname="Dart_Null")]
  public static unowned Handle null();
  
  [CCode (cname="dart_handle_wrap")]
  public static Handle wrap<T>(T object, Handle cls, string? constructor = null, bool is_nullable = false, out Dart.Handle on_error = null) throws DartError;
  
  [CCode (cname="dart_handle_peek_type")]
  public GLib.Type peek_type(out Dart.Handle on_error = null) throws DartError;
  
  [CCode (cname="dart_handle_unwrap")]
  public T? unwrap<T>(out Dart.Handle on_error = null) throws DartError;
  
  
  [CCode (cname="dart_handle_rethrow")]
  public void rethrow();
  
  [CCode (cname="dart_handle_catch")]
  public void recast_error(out Dart.Handle on_error = null) throws DartError;
  
  [CCode (cname="Dart_ObjectIsType")]
  public Handle is_type(ClassHandle class, out bool is_instance);
}

[Compact]
[CCode (cname="struct _Dart_Handle", cheader_filename="dart_compat.h", type_check_function="Whoa")]
public class LibraryHandle : Handle {
  [CCode (cname="Dart_SetNativeResolver")]
  public unowned Handle set_native_resolver(NativeEntryResolver resolver, NativeEntrySymbol symbol);
  
  [CCode (cname="Dart_RootLibrary")]
  public static unowned LibraryHandle get_root_library();
  
  [CCode (cname="Dart_GetClass")]
  public unowned ClassHandle get_class(StringHandle name);
  
  [CCode (cname="Dart_CreateNativeWrapperClass")]
  public unowned Handle create_native_wrapper_class(StringHandle name, int field_count);
}

[Compact]
[CCode (cname="struct _Dart_Handle", cheader_filename="dart_compat.h")]
public class ListHandle : Handle {
  [CCode (cname="Dart_NewList")]
  public ListHandle(int length);
  
  [CCode (cname="Dart_ListSetAt")]
  public Handle set(int i, Handle value);
  
  [CCode (cname="Dart_ListLength")]
  public unowned Handle length(out int length);
  
  [CCode (cname="Dart_ListGetAt")]
  public Handle get(int i);
}

[Compact]
[CCode (cname="struct _Dart_Handle", cheader_filename="dart_compat.h")]
public class ClassHandle : Handle {
  [CCode (cname="Dart_Allocate")]
  public Handle allocate();
}

[Compact]
[CCode (cname="struct _Dart_Handle", cheader_filename="dart_compat.h", has_type_id=false)]
public class StringHandle : Handle {
  [CCode (cname="Dart_NewStringFromCString")]
  public StringHandle(string value);
  
  [CCode (cname="Dart_StringToCString")]
  public unowned Handle to_c_string(out unowned string cstring);
}

[Compact]
[CCode (cname="struct _Dart_Handle", cheader_filename="dart_compat.h", has_type_id=false)]
public class APIErrorHandle : Handle {
  [CCode (cname="Dart_NewApiError")]
  public APIErrorHandle(string value);
}

public errordomain DartError {
  API_ERROR,
  NOT_A_GI_OBJECT,
  UNEXPECTED_CAST,
  CATCH
}

}