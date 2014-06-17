/* -*- Mode: C; indent-tabs-mode: s; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * lib.c
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

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>

#include <girepository.h>

#include "include/dart_api.h"
#include "include/dart_native_api.h"

/***
 * TODO(astark):
 *   Map namespaces to library files.
 *   Load a namespace.
 *   Visit members of namespace.
 *   Create classes.
 *   Create functions.
 *   Create statics and constructors.
 *  
 * 
 */

Dart_NativeFunction ResolveName(Dart_Handle name, int argc, bool* auto_setup_scope);
const uint8_t* ResolveFunctionPtr(Dart_NativeFunction nf);

Dart_Handle HandleError(Dart_Handle handle) {
  if (Dart_IsError(handle)) {
    Dart_PropagateError(handle);
  }
  return handle;
}

static Dart_Handle parent_library;

DART_EXPORT Dart_Handle dart_gir_Init(Dart_Handle _parent_library) {
  parent_library = _parent_library;
  if (!dlopen("libgirepository-1.0.so.1",RTLD_NOW))
    return NULL;
  if (Dart_IsError(parent_library)) return parent_library;

  Dart_Handle result_code =
      Dart_SetNativeResolver(parent_library, ResolveName, ResolveFunctionPtr);
  if (Dart_IsError(result_code)) return result_code;


  return Dart_Null();
}

void HelloWorld(Dart_NativeArguments arguments) {
  Dart_Handle result = HandleError(Dart_NewStringFromCString("Hello Dart."));
  Dart_SetReturnValue(arguments, result);
}

void dart_gir_gobject_unref (void* isolate_data, Dart_WeakPersistentHandle handle, void* peer) {
  if (peer == NULL) return;
  g_object_unref(peer);
}

Dart_Handle dart_gir_create_proxy_gobject_unowned (GObject* object, const char* name) {
  Dart_Handle cls = Dart_GetClass(Dart_RootLibrary(), Dart_NewStringFromCString(name));
  Dart_Handle instance = object==NULL?Dart_Null():Dart_New(cls, Dart_Null(), 0, 0); 
  
  Dart_SetNativeInstanceField(instance, 0, (intptr_t) object);
  //Dart_NewWeakPersistentHandle(instance, object, 0, &dart_gir_gobject_unref);

  return instance;
}


Dart_Handle dart_gir_create_proxy_gobject_owned (GObject* object, const char* name) {
  Dart_Handle instance = dart_gir_create_proxy_gobject_unowned (object, name);
  Dart_NewWeakPersistentHandle(instance, object, 0, &dart_gir_gobject_unref);
  return instance;
}

Dart_Handle dart_gir_create_string_list_unowned (const char** names) {
  intptr_t length = 0;
  intptr_t i = 0;
  for (; names[length] != NULL; length++)
    ;
  Dart_Handle result = HandleError(Dart_NewList(length));
  for (; i < length; i++) {
    Dart_Handle string = HandleError(Dart_NewStringFromCString(names[i]));
    Dart_ListSetAt (result, i, string);
    //g_free(names[i]);
  }
  //g_free(names);
  return result;
}

Dart_Handle dart_gir_create_string_list_owned (char** names) {
  Dart_Handle result = dart_gir_create_string_list_unowned ((const char**)names);
  intptr_t length = 0;
  for (; names[length] != NULL; length++) {
    g_free(names[length]);
  }
  g_free(names);
  return result;
}

GObject* dart_gir_proxy_gobject_unwrap_unowned (Dart_Handle object) {
  if (Dart_IsNull(object)) 
    return NULL;
  Dart_Handle cls = Dart_GetClass(Dart_RootLibrary(), Dart_NewStringFromCString("GObject"));
  bool is_gobject;
  Dart_ObjectIsType(object,cls,&is_gobject);
  if (!is_gobject) {
    Dart_NewApiError("Object was not a GObject type.");
    return NULL;
  }
  int parameter_count;
  Dart_GetNativeInstanceFieldCount(object, &parameter_count);
  if (parameter_count < 1) {
    Dart_NewApiError("Object was not a GObject type.");
    return NULL;
  }
  GObject* result;
  Dart_GetNativeInstanceField(object, 0, (intptr_t*) &result);
  return result;
}

void dart_gir_repository_get_default(Dart_NativeArguments arguments) {
  Dart_Handle result = HandleError(dart_gir_create_proxy_gobject_unowned(G_OBJECT(g_irepository_get_default ()), "GIRepository"));
  Dart_SetReturnValue(arguments, result);
}

void dart_gir_repository_get_loaded_namespaces(Dart_NativeArguments arguments) {
  if (Dart_GetNativeArgumentCount(arguments) < 1) {
    Dart_NewApiError("Object was not a GObject type.");
    return;
  }
  Dart_Handle girepositoryProxy = HandleError(Dart_GetNativeArgument(arguments,0));
  Dart_Handle cls = Dart_GetClass(Dart_RootLibrary(), Dart_NewStringFromCString("GIRepository"));
  bool is_gobject;
  Dart_ObjectIsType(girepositoryProxy,cls,&is_gobject);
  if (!is_gobject) {
    Dart_NewApiError("Object was not a GIRepository type.");
    return;
  }
  GIRepository* giRepository = (GIRepository*) dart_gir_proxy_gobject_unwrap_unowned(girepositoryProxy);
  Dart_Handle result = dart_gir_create_string_list_owned (g_irepository_get_loaded_namespaces (giRepository)); 
  Dart_SetReturnValue(arguments, result);
}

Dart_NativeFunction ResolveName(Dart_Handle name, int argc, bool* auto_setup_scope) {
  if (!Dart_IsString(name)) return NULL;
  Dart_NativeFunction result = NULL;
  const char* cname;
  HandleError(Dart_StringToCString(name, &cname));

  if (strcmp("dart_gir_repository_get_default", cname) == 0)           return dart_gir_repository_get_default;
  if (strcmp("dart_gir_repository_get_loaded_namespaces", cname) == 0) return dart_gir_repository_get_loaded_namespaces;
  
  return result;
}

const uint8_t* ResolveFunctionPtr(Dart_NativeFunction nf) {
  if (nf == dart_gir_repository_get_default)           return (const uint8_t*) "dart_gir_repository_get_default";
  if (nf == dart_gir_repository_get_loaded_namespaces) return (const uint8_t*) "dart_gir_repository_get_loaded_namespaces";
  
  return NULL;
}
