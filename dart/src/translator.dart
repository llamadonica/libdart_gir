part of libdart_gir;

abstract class Translator {
  factory Translator() => new _Translator();
  Translator._();
  /***
   * Add a dependency mapping that maps a GI package dependency onto a Dart
   * formatted URI. Optional "trueUri" can be used for batch operation to
   * use a separate URI for probing.
   *
   * Must be called manually.
   */
  void mapDependency (String giPackage, String packageUri, [String trueUri = null]);
  
  /***
   * Add a required dependency to the list of requirements. The trueUri is
   * probed for some required Type information and constants, and the packageUri
   * is added to the list of imports.
   *
   * Called by the visitor. Can also be called manually.
   */
  void requireDependency (String giPackage);
  /***
   * Add all the remaining dependencies, including the library extension. If
   * there aren't any dependencies, it will also create the TypedData
   * superclass, and create some default mappings.
   * 
   * It will also create the generic native mathod.
   */
  void addBaseDefinitions ();
}

class _Translator extends Translator {
  Map<String,String> _packageUris = new Map<String,String>();
  Map<String,String> _trueUris = new Map<String,String>();
  _Translator() : super._();
  void mapDependency (String giPackage, String packageUri, [String trueUri = null]) {
    if (trueUri == null)
      trueUri = packageUri;
    _packageUris[giPackage] = packageUri;
    _trueUris[giPackage] = trueUri;
  }
}
