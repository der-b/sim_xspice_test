# XSPICE Codemodel Compile Test

## Prerequisites

Ngspice have to be installed.

## Compile

The compile script checks for all needed executables, header files and c-files and compiles the codemodel.

``` console
% ./compile.sh
```

Afterwards, the codemodle can be found under *./codemodel/clk.cm*

## Test with ngspic

``` console
% ngspice ./test.cir
```

Leave ngspiec interactive mode with *quit*.

