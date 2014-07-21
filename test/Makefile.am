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
  --pkg=gobject-introspection-1.0 \
  --vapidir=../src

bin_PROGRAMS = testsuite

testsuite_VALASOURCES = \
  gir_test_suite.vala

testsuite_SOURCES = \
    $(testsuite_VALASOURCES)

testsuite_LDADD = $(GOBJECT_INTROSPECTION_LIBS) $(GLIB_LIBS)

CLEANFILES = \
  $(testsuite_VALASOURCES:.vala=.c) \
  libdart_gir_la_vala.stamp
  