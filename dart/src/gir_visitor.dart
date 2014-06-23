part of libdart_gir;

abstract class GirVisitable {
  void accept (GirVisitor v);
}

abstract class GirVisitor {
  void visitNamespace (Namespace e);
  void visitBaseInfo (BaseInfo e);
  /*
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
  */
}

class GirDebugVisitor implements GirVisitor {
  void visitNamespace (Namespace e) {
    print("//Visiting ${e.namespace}");
  }
  void visitBaseInfo (BaseInfo e) {
    print("//  Visiting ${e.name}");
    for (var i in e.attributes) {
      print("//    ${i.attribute} = ${i.value}");
    }
  }
}