## Process this file with automake to produce Makefile.in

## Created by Anjuta

AM_CPPFLAGS = \
    $(GLIB_CFLAGS) \
	$(GOBJECT_INTROSPECTION_CFLAGS) \
	-I/opt/google/dartsdk/include \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\"

AM_CFLAGS =\
	 -Wall\
	 -g
	 
AM_VALAFLAGS = \
  --pkg=gobject-introspection-1.0

lib_LTLIBRARIES = libdart_gir.la

libdart_gir_la_VALA_SOURCES = \
    dart_gir_core.vala \
	gir_visitor.vala

libdart_gir_la_SOURCES = \
	libdart_gir_core.c \
    $(libdart_gir_la_VALA_SOURCES) \
    dart.vapi

libdart_gir_la_LDFLAGS = -ldl

libdart_gir_la_LIBADD = $(GOBJECT_INTROSPECTION_LIBS) $(GLIB_LIBS)

CLEANFILES = \
  $(libdart_gir_la_VALA_SOURCES:.vala=.c) \
  libdart_gir_la_vala.stamp

include_HEADERS = \
	libdart_gir.h

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libdart_gir-0.1.pc

EXTRA_DIST = \
	libdart_gir-0.1.pc.in
