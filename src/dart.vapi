[CCode (cheader_filename="dart_api.h", cprefix="Dart_", lowercase_cprefix="Dart_")]
namespace Dart {
  
[CCode (has_target = false)]
public delegate void NativeFunction(NativeArguments arguments);

[CCode (has_target = false)]
public delegate unowned string? NativeEntrySymbol(NativeFunction function);

[CCode (has_target = false, type="Blah")]
public delegate NativeFunction? NativeEntryResolver(Handle name,  int number_of_arguments, out bool auto_setup_scope);

[CCode (cname="Dart_TypedData_Type")]
public enum TypedDataType {
  [CCode (cname="Dart_TypedData_kByteData")]
  BYTE_DATA,
  [CCode (cname="Dart_TypedData_kInt8")]
  INT8,
  [CCode (cname="Dart_TypedData_kUint8")]
  UINT8,
  [CCode (cname="Dart_TypedData_kUint8Clamped")]
  Uint8Clamped,
  [CCode (cname="Dart_TypedData_kInt16")]
  INT16,
  [CCode (cname="Dart_TypedData_kUint16")]
  UINT16,
  [CCode (cname="Dart_TypedData_kInt32")]
  INT32,
  [CCode (cname="Dart_TypedData_kUint32")]
  UINT32,
  [CCode (cname="Dart_TypedData_kInt64")]
  INT64,
  [CCode (cname="Dart_TypedData_kUint64")]
  UINT64,
  [CCode (cname="Dart_TypedData_kFloat32")]
  FLOAT32,
  [CCode (cname="Dart_TypedData_kFloat64")]
  FLOAT64,
  [CCode (cname="Dart_TypedData_kFloat32x4")]
  FLOAT32x4,
  [CCode (cname="Dart_TypedData_kInvalid")]
  INVALID;
}

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
  
  [CCode (cname="Dart_IsInteger")]
  public bool is_int();
  
  [CCode (cname="dart_handle_wrap")]
  public static Handle wrap<T>(T object, Handle cls, string? constructor = null, bool is_nullable = false, ref Dart.Handle on_error) throws DartError;
  
  [CCode (cname="dart_handle_peek_type")]
  public GLib.Type peek_type(ref Dart.Handle on_error) throws DartError;
  
  [CCode (cname="dart_handle_unwrap")]
  public T? unwrap<T>(ref Dart.Handle on_error) throws DartError;
  
  
  [CCode (cname="dart_handle_rethrow")]
  public void rethrow();
  
  [CCode (cname="dart_handle_catch")]
  public void recast_error(ref Dart.Handle on_error) throws DartError;
  
  [CCode (cname="Dart_ObjectIsType")]
  public Handle is_type(ClassHandle class, out bool is_instance);
  
  [CCode (cname="Dart_InstanceGetType")]
  public Handle get_type();
  
  [CCode (cname="Dart_GetField")]
  public Handle get_field(StringHandle name);
  
  [CCode (cname="Dart_SetField")]
  public Handle set_field(StringHandle name, Handle value);
  
  [CCode (cname="Dart_ToString")]
  public StringHandle to_string();
  
  [CCode (cname="Dart_Invoke")]
  public Handle invoke(StringHandle name, [CCode (array_length_pos=1.9)] Handle[] arguments);
  
  [CCode (cname="Dart_TypedDataAcquireData")]
  public Handle acquire_data(out TypedDataType type, out void* data, out int length);
  
  [CCode (cname="Dart_TypedDataReleaseData")]
  public Handle release_data();
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
public class IntHandle : Handle {
  [CCode (cname="Dart_NewInteger")]
  public IntHandle(int64 value);
  
  [CCode (cname="Dart_IntegerToInt64")]
  public Handle to_int64(out int64 value);
  
  [CCode (cname="Dart_NewIntegerFromHexCString")]
  public IntHandle.from_hex_c_string(string value);
}

[Compact]
[CCode (cname="struct _Dart_Handle", cheader_filename="dart_compat.h")]
public class ClassHandle : Handle {
  [CCode (cname="Dart_Allocate")]
  public Handle allocate();
  
  [CCode (cname="Dart_New")]
  public Handle new(Handle constructor, [CCode (array_length_pos=1.9)] Handle[] arguments);
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
public class DoubleHandle : Handle {
  [CCode (cname="Dart_NewDouble")]
  public DoubleHandle(double value);
}

[Compact]
[CCode (cname="struct _Dart_Handle", cheader_filename="dart_compat.h", has_type_id=false)]
public class APIErrorHandle : Handle {
  [CCode (cname="Dart_NewApiError")]
  public APIErrorHandle(string value);
}
//Dart_NewBoolean

[Compact]
[CCode (cname="struct _Dart_Handle", cheader_filename="dart_compat.h", has_type_id=false)]
public class BooleanHandle : Handle {
  [CCode (cname="Dart_NewBoolean")]
  public BooleanHandle(bool value);
}
public errordomain DartError {
  API_ERROR,
  NOT_A_GI_OBJECT,
  UNEXPECTED_CAST,
  CATCH
}

} 