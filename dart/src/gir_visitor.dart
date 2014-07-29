part of libdart_gir;

abstract class GirVisitable {
  void accept (ContainerDeclaration parent, GirVisitor v);
}

class GirVisitor {
  final GirGlobalState _state;
  GirVisitor(GirGlobalState this._state);
  
  LibraryDeclaration visitNamespace (Namespace e) {
    var decl = new LibraryDeclaration(_state);
    decl.name = e.namespace;
    for (var dependency in e.dependencies) {
      decl.requireDependency(dependency); 
    } 
    return decl;
  }
  Future<DartDeclaration> visitBaseInfo (ContainerDeclaration parent, BaseInfo e) {
    var result = new Completer<DartDeclaration>();
    new Future(() {
      _state.debug("Visiting ${e.name}");
      if (e is StructInfo) {
        var decl = visitStructure(parent.topLibrary, e);
        parent.addDeclaration(decl);
        result.complete(decl);
      } else if (e is FieldInfo) {
        var decl = visitField(parent.topLibrary, e);
        parent.addDeclaration(decl);
        result.complete(decl);
      } else if (e is FlagsInfo) {
        var decl = visitEnum(parent.topLibrary, e, true);
        parent.addDeclaration(decl);
        result.complete(decl);
      } else if (e is EnumInfo) {
        var decl = visitEnum(parent.topLibrary, e, false);
        parent.addDeclaration(decl);
        result.complete(decl);
      } else if (e is ValueInfo) {
        var decl = visitEnumValue(parent.topLibrary, e, parent);
        parent.addDeclaration(decl);
        result.complete(decl);
      } else if (e is ConstantInfo) {
        var decl = visitConst(parent.topLibrary, e);
        parent.addDeclaration(decl);
        result.complete(decl);
      } else if (e is CallbackInfo) {
        var decl = visitDelegate(parent.topLibrary, e);
        parent.addDeclaration(decl);
        result.complete(decl);
      } else if (e is ArgInfo) {
        var decl = visitArgument(parent.topLibrary, e, parent);
        parent.addDeclaration(decl);
        result.complete(decl);
      }else {
        result.complete(null);
      } 
    });
    return result.future;
  }

  /*
  void visitObject (ObjectInfo e);
  void visitProperty (PropertyInfo e);

  */
  DartDeclaration visitConst (LibraryDeclaration library, ConstantInfo e) {
    var result = new ConstDeclaration (library, e, e.name, e.type.tag.constTypeName(), e.value);
    return result;
  }
  DartDeclaration visitStructure (LibraryDeclaration library, StructInfo e) {
    var result = new StructDeclaration(library,e,e.name);
    result.size = e.size;
    return result;
  }

  DartDeclaration visitField (LibraryDeclaration library, FieldInfo e) {
    var result = new FieldDeclaration (library, e, underscoreNameToCamelCase(e.name));
    result.offset = e.offset;
    
    result.type = library.typeName(e.type);
    if (e.flags.readable && e.type.tag !=  TypeTag.VOID) { 
      result.hasGetter = true;
      result.fieldGetter = library.fieldGetterName(e.type, '__buffer__', e.offset);
    }
    if (e.flags.writable && e.type.tag !=  TypeTag.VOID) {
      result.hasSetter = true;
      result.fieldSetter = library.fieldSetterName(e.type, '__buffer__', e.offset, '__value__');
    }
    return result;
  }
  DartDeclaration visitDelegate (LibraryDeclaration library, CallbackInfo e) {
    var result = new DelegateDeclaration(library,e,e.name);
    result.returnType =
        (e.returnType.tag == TypeTag.VOID)?'void':library.typeName(e.returnType);
    return result;
  }
  DartDeclaration visitEnum (LibraryDeclaration library, EnumInfo e, bool isFlag) {
    var result = new EnumDeclaration(library,e,e.name,isFlag);
    result.type = e.storageType;
    return result;
  }
  DartDeclaration visitEnumValue (LibraryDeclaration library, ValueInfo e,
      EnumDeclaration parent) {
    var result = new EnumValueDeclaration(library,e,e.name.toUpperCase(),
        parent);
    result.value = e.value;
    return result;
  }
  /*
  void visitInterface (InterfaceInfo e);
  
  void visitVirtualFunction (VFuncInfo e);
  
  
  void visitUnion (UnionInfo e);
  
  void visitSignal (SignalInfo e);
  */
  DartDeclaration visitArgument (LibraryDeclaration library, ArgInfo e, 
                                 ContainerDeclaration parent) {
    var result = new ArgumentExpression (library,e.type,e.name);
    return result;
  }
}

String underscoreNameToCamelCase (String value) {
  var buffer = new StringBuffer('');
  var runeIterator = value.runes.iterator;
  while (runeIterator.moveNext()) {
    if (runeIterator.current == 95) {
      if (!runeIterator.moveNext()) return buffer.toString();
      while (runeIterator.current == 95) {
        if (!runeIterator.moveNext()) return buffer.toString();
      }
      buffer.write(new String.fromCharCode(runeIterator.current).toUpperCase()); 
      continue;
    }
    buffer.write(new String.fromCharCode(runeIterator.current));
  }
  return buffer.toString();
}