part of libdart_gir;

abstract class GirVisitable {
  void accept (GirVisitor v);
}

abstract class GirVisitor {
  void visitNamespace (Namespace e);
  
  void visitMethod (FunctionInfo e);
  
  void visitObject (ObjectInfo e);
  void visitProperty (PropertyInfo e);
  
  void visitStructure (StructInfo e);
  void visitField (FieldInfo e);
  
  void visitDelegate (CallbackInfo e);
  
  void visitEnum (EnumInfo e, [bool isFlags = false]);
  void visitEnumValue (ValueInfo e);
  
  void visitInterface (InterfaceInfo e);
  
  void visitVirtualFunction (VFuncInfo e);
  
  void visitConstant (ConstantInfo e);
  
  void visitUnion (UnionInfo e);
  
  void visitSignal (SignalInfo e);
  
  void visitArgument (ArgInfo e);
}