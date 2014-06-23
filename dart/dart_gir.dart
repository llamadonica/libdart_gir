library libdart_gir;

import 'dart-ext:dart_gir';
import 'dart:collection';
import 'dart:nativewrappers';

part 'src/object.dart';
part 'src/repository.dart';
part 'src/typelib.dart';
part 'src/namespace.dart';
part 'src/baseinfo.dart';

part 'src/gir_visitor.dart';
part 'src/translator.dart';

main() {
  var repo =  Repository.$default;
  var namespace = new Namespace(repo, "GLib");
  var visitor = new GirDebugVisitor();
  namespace.accept(visitor);
}