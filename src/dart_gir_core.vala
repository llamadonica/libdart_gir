/* -*- Mode: Vala; indent-tabs-mode: s; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * dart_gir_core.vala
 * Copyright (C) 2014 Adam Stark <llamadonica@gmail.com>
 * 
 * libdart-gir is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * libdart-gir is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

[ CCode (cprefix="dart_gir") ]
namespace DartGir {

[CCode (cname="dart_gir_Init", type="DART_EXPORT Dart_Handle")]
public unowned Dart.Handle init(Dart.LibraryHandle parent_library) {
  if (parent_library.is_error())
    return parent_library;
  unowned Dart.Handle result_code = 
    parent_library.set_native_resolver(null,null);
  if (result_code.is_error())
    return result_code;
  return Dart.Handle.null();  
}

public unowned Dart.Handle fromStringArray(string[] strings) {
  
}

}