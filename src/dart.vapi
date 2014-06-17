[CCode (cheader_filename="dart_api.h", cprefix="Dart_", lowercase_cprefix="Dart_")]
namespace Dart {
  
[CCode (has_target = false)]
public delegate void NativeFunction(NativeArguments arguments);

[CCode (has_target = false)]
public delegate unowned string NativeEntrySymbol(NativeFunction function);

[CCode (has_target = false)]
public delegate NativeFunction NativeEntryResolver(Handle name, int number_of_arguments, out bool auto_setup_scope);

[CCode (cname="struct _Dart_NativeArguments")]
public class NativeArguments {
}

[CCode (cname="struct _Dart_Handle", cheader_filename="dart_compat.h")]
public class Handle {
  [CCode (cname="Dart_IsError")]
  public bool is_error();
  
  [CCode (cname="Dart_Null")]
  public static unowned Handle null();
}

[CCode (cname="struct _Dart_Handle", cheader_filename="dart_compat.h")]
public class LibraryHandle : Handle {
  [CCode (cname="Dart_SetNativeResolver")]
  public unowned Handle set_native_resolver(NativeEntryResolver resolver, NativeEntrySymbol symbol);
}

}