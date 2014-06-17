## Process this file with automake to produce Makefile.in

## Created by Anjuta

AM_CPPFLAGS = \
	$(GOBJECT_INTROSPECTION_CFLAGS) \
	-I/opt/google/dartsdk \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\"

AM_CFLAGS =\
	 -Wall\
	 -g

lib_LTLIBRARIES = libdart_gir.la


libdart_gir_la_SOURCES = \
	lib.c

libdart_gir_la_LDFLAGS = -ldl

libdart_gir_la_LIBADD = $(GOBJECT_INTROSPECTION_LIBS)



include_HEADERS = \
	libdart_gir.h

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libdart_gir-0.1.pc

EXTRA_DIST = \
	libdart_gir-0.1.pc.in
