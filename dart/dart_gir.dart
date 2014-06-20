library libdart_gir;

import 'dart-ext:dart_gir';

part 'src/object.dart';
part 'src/repository.dart';
part 'src/typelib.dart';
part 'src/namespace.dart';

main() {
  var repo =  Repository.$default;
  repo.require("GLib");
  print(repo.getDependencies("GLib"));
}
