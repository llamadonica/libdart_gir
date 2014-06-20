part of libdart_gir;

abstract class Namespace {
  Namespace._();
}

class _Namespace extends Namespace {
  final Repository repository;
  final string namespace;
  _Namespace(this.repository, this.namespace) : super._();
}
