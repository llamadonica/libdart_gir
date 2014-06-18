/* -*- Mode: Vala; indent-tabs-mode: s; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * dart_compat.h
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

#include <dart_api.h>
#include <stdio.h>

#ifndef DART_COMPAT_H
#define DART_COMPAT_H 1

#define DART_BIND(cname,name) if (strcmp(#name, cname) == 0) return name;

GQuark dart_dart_error_quark (void) {
	return g_quark_from_static_string ("Dart_dart_error-quark");
}

typedef enum  {
	DART_DART_ERROR_API_ERROR,
	DART_DART_ERROR_NOT_A_GI_OBJECT,
	DART_DART_ERROR_CATCH
} Dart_DartError;

#define DART_DART_ERROR dart_dart_error_quark ()

void dart_handle_unref (Dart_Handle handle) {
  return;
}
Dart_Handle dart_handle_ref (Dart_Handle handle) {
  return handle;
}

void dart_handle_rethrow (Dart_Handle handle) {
  if (Dart_IsError(handle)) {
    Dart_PropagateError(handle);
  }
}

void dart_handle_catch (Dart_Handle handle, Dart_Handle* set_on_error, GError **error) {
  if (Dart_IsError(handle)) {
    g_set_error(error, DART_DART_ERROR, DART_DART_ERROR_CATCH, "");
    if (set_on_error != NULL) *set_on_error = handle;
  }
  return;
}

typedef struct _dart_generic_wrapper dart_generic_wrapper;

struct _dart_generic_wrapper {
	GType t_type;
	GBoxedCopyFunc t_dup_func;
	GDestroyNotify t_destroy_func;
	gconstpointer value;
};

void dart_generic_wrapper_finalize (void* isolate_callback_data, 
    Dart_WeakPersistentHandle handle, void* peer) {
  fprintf (stderr, "Entered GC: dart_generic_wrapper_finalize\n");
  dart_generic_wrapper *captured = (dart_generic_wrapper*) peer;
  if (captured->t_destroy_func != NULL && captured->value != NULL) 
    captured->t_destroy_func(captured->value);
  g_slice_free(dart_generic_wrapper,peer);
}

Dart_Handle dart_handle_wrap (GType t_type, GBoxedCopyFunc t_dup_func, 
    GDestroyNotify t_destroy_func, gconstpointer value, Dart_Handle cls, 
    const char *constructor, gboolean is_nullable,Dart_Handle* set_on_error,
    GError** error) {
  
  fprintf (stderr, "Entered Dart.Handle.wrap<T>\n");
  fprintf (stderr, "  wrap<%s>\n", g_type_name (t_type));
  Dart_Handle ctor_name = 
      constructor==NULL?Dart_Null():Dart_NewStringFromCString(constructor);
  if (value==NULL && !is_nullable){
    fprintf (stderr, "  returning `null`\n");
    return Dart_Null();
  }
  
  //Dart_Handle instance = Dart_New(cls, ctor_name, 0, 0);
  Dart_Handle instance = Dart_Allocate(cls);
  
  dart_handle_catch(instance, set_on_error, error);
  if (error != NULL && *error != NULL) {
    if (t_destroy_func != NULL && value != NULL)
      t_destroy_func(value);
    fprintf (stderr, "Caught error in new %s\n", g_type_name (t_type));
    return instance;
  }
  
  dart_generic_wrapper *captured = g_slice_new(dart_generic_wrapper);
  captured->t_type = t_type;
  captured->t_dup_func = t_dup_func;
  captured->t_destroy_func = t_destroy_func;
  captured->value = value;
  
  Dart_Handle caught_on_error = Dart_SetNativeInstanceField(instance, 0, 
      (intptr_t) captured);
  dart_handle_catch(caught_on_error, set_on_error, error);
  if (error != NULL && *error != NULL) {
    if (t_destroy_func != NULL && value != NULL)
      t_destroy_func(value);
    g_slice_free(dart_generic_wrapper,captured);
    fprintf (stderr, "Caught error in Dart_SetNativeInstanceField %s\n", g_type_name (t_type));
    return caught_on_error;
  }
  Dart_NewWeakPersistentHandle(instance, (void*) captured, 0, 
      &dart_generic_wrapper_finalize);
  
  fprintf (stderr, "Exiting normally from Dart.Handle.wrap<T>\n");
  return instance;
}

GType dart_handle_peek_type (Dart_Handle handle, Dart_Handle* set_on_error, GError** error) {
  if (Dart_IsNull(handle))
    return G_TYPE_POINTER;
  dart_generic_wrapper *captured;
  dart_handle_catch(Dart_GetNativeInstanceField(handle, 0, 
      (intptr_t*) &captured), set_on_error, error);
  if (error != NULL && *error != NULL) 
    return 0;
  return captured->t_type;
}


gpointer dart_handle_unwrap (Dart_Handle handle, GType t_type,
    GBoxedCopyFunc t_dup_func, GDestroyNotify t_destroy_func,
    Dart_Handle* set_on_error, GError** error) {
  if (Dart_IsNull(handle))
    return NULL;
  dart_generic_wrapper *captured;
  dart_handle_catch(Dart_GetNativeInstanceField(handle, 0, 
      (intptr_t*) &captured), set_on_error, error);
  if (*error != NULL) 
    return NULL;
  if (!g_type_is_a (captured->t_type, t_type)) {
    *error = g_error_new(DART_DART_ERROR, DART_DART_ERROR_NOT_A_GI_OBJECT, 
        "Unexpected object. Expected %s, but found %s.", g_type_name(t_type),
        g_type_name(captured->t_type));
    return NULL;
  }
  return captured->value;
}

#endif