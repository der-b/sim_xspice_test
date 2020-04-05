#!/bin/sh

CM_DIR=./codemodel/

echo -n "searching for dlmain.c ... "
DLMAIN=/usr/share/ngspice/dlmain.c 

if [ -f ${DLMAIN} ]; then
        echo "found in $DLMAIN"
else 
        echo "not found: exit"
        exit 1
fi

echo -n "searching for ccmp ... "
CMPP=$(which cmpp 2> /dev/null)

if [ -z "${CMPP}" ]; then
        echo "not found: exit"
        exit 1
else
        echo "found in $CMPP"
fi

echo -n "searching for gcc ... "
CC=$(which gcc 2> /dev/null)

if [ -z "${CC}" ]; then
        echo "not found: exit"
        exit 1
else
        echo "found in $CC"
fi

NGSPICE_HEADERS="/usr/include/ngspice"
echo -n "searching for ngspice headers ... "
if [ -d "${NGSPICE_HEADERS}" ]; then
        echo "found in $NGSPICE_HEADERS"
else 
        echo "not found: exit"
        exit 1
fi

CFLAGS="-I${CM_DIR} -g -O1 -Wall -Wextra -Wmissing-prototypes -Wstrict-prototypes -Wnested-externs -Wredundant-decls -Wconversion -Wno-unused-but-set-variable -fPIC"

set -x

CMPP_IDIR=$CM_DIR CMPP_ODIR=$CM_DIR $CMPP -lst

$CC $CFLAGS -o $CM_DIR/dlmain.o -c $DLMAIN 

CMPP_IDIR=$CM_DIR/clk CMPP_ODIR=$CM_DIR/clk $CMPP -mod

$CC $CFLAGS -I$CM_DIR/clk -o $CM_DIR/clk/cfunc.o -c $CM_DIR/clk/cfunc.c

CMPP_IDIR=$CM_DIR/clk CMPP_ODIR=$CM_DIR/clk $CMPP -ifs

$CC $CFLAGS -I$CM_DIR/clk -o $CM_DIR/clk/ifspec.o -c $CM_DIR/clk/ifspec.c

$CC $CFLAGS --shared $CM_DIR/dlmain.o $CM_DIR/clk/cfunc.o $CM_DIR/clk/ifspec.o -lm -o $CM_DIR/clk.cm

