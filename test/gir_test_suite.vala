class Test : GLib.Object {
    public static int main(string[] args) {
        var namespace_ = Namespace.new(GI.Repository.get_default(),"GLib");
        var visitor = new GirDebugVisitor();
        namespace_.accept(visitor);
        return 0;
    }
}

public interface GirVisitor : GLib.Object{
  public abstract void visit_namespace (Namespace e);
  public abstract void visit_base_info (BaseInfo e);
}
private class GirDebugVisitor : GLib.Object, GirVisitor {
  public virtual void visit_namespace (Namespace e) {
    print(@"//Visiting $(e.get_namespace())\n");
  }
  public virtual void visit_base_info (BaseInfo e) {
    print(@"//  Visiting $(e.get_base_info().get_name())\n");
    GI.AttributeIter iterator = {};
    string attribute, value;
    while (e.get_base_info().iterate_attributes(ref iterator, out attribute, out value)) {
      print(@"//    $attribute = $value\n");
    }
  }
  public GirDebugVisitor() {
  }
}

public interface GirVisitable : GLib.Object {
  public abstract void accept(GirVisitor visitor);
}

public interface Namespace : GirVisitable {
  public abstract GI.Repository get_repository();
  public abstract string get_namespace();
  public static Namespace @new(GI.Repository repository, string @namespace) throws GLib.Error {
    return new NamespaceImpl(repository, namespace);
  }
}

private class NamespaceImpl : GLib.Object, GirVisitable, Namespace {
  private GI.Repository _repository;
  private string _namespace;
  
  public virtual GI.Repository get_repository() {
    return _repository;
  }
  public virtual string get_namespace() {
    return _namespace;
  }
  public NamespaceImpl (GI.Repository repository, string @namespace) throws GLib.Error {
    _repository = repository;
    _namespace = @namespace;
    _repository.require(_namespace, null, 0);
  }
  public virtual void accept(GirVisitor visitor) {
    visitor.visit_namespace(this);
    for (var i = 0; i < _repository.get_n_infos(_namespace); i++) {
      new BaseInfoImpl(_repository.get_info(_namespace,i)).accept(visitor);
    }
  }
}

public interface BaseInfo : GirVisitable {
  public abstract GI.BaseInfo get_base_info();
  public static BaseInfo @new(GI.BaseInfo base_info) {
    return new BaseInfoImpl(base_info);
  }
}
private class BaseInfoImpl : GLib.Object, GirVisitable, BaseInfo {
  private GI.BaseInfo _base_info;
  
  public virtual GI.BaseInfo get_base_info() {
    return _base_info;
  }
  public virtual void accept(GirVisitor visitor) {
    visitor.visit_base_info(this);
  }
  public BaseInfoImpl(GI.BaseInfo base_info) {
    _base_info = base_info;
  }
}