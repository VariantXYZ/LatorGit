#/bin/bash

make -C external/rgbds clean
make -C external/rgbds CC=emcc PNGCFLAGS='' PNGLDFLAGS='' PNGLDLIBS='' LDFLAGS="-s MODULARIZE=1 -lproxyfs.js -s ASYNCIFY -s EXPORTED_RUNTIME_METHODS=['PROXYFS','FS'] -s EXPORT_NAME=createRgbAsm" CFLAGS="-O3 -flto -DNDEBUG" rgbasm -j
make -C external/rgbds CC=emcc PNGCFLAGS='' PNGLDFLAGS='' PNGLDLIBS='' LDFLAGS="-s MODULARIZE=1 -lproxyfs.js -s ASYNCIFY -s EXPORTED_RUNTIME_METHODS=['PROXYFS','FS'] -s EXPORT_NAME=createRgbLink" CFLAGS="-O3 -flto -DNDEBUG" rgblink -j
make -C external/rgbds CC=emcc PNGCFLAGS='' PNGLDFLAGS='' PNGLDLIBS='' LDFLAGS="-s MODULARIZE=1 -lproxyfs.js -s ASYNCIFY -s EXPORTED_RUNTIME_METHODS=['PROXYFS','FS'] -s EXPORT_NAME=createRgbGfx -s USE_LIBPNG" CFLAGS="-O3 -flto -DNDEBUG" rgbgfx -j