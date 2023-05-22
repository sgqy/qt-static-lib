#!/bin/bash
../src/configure \
 -prefix '/opt/qt5.12.3s' \
 -recheck-all -opensource -confirm-license \
 -platform linux-clang -release -static -ltcg -silent \
 -nomake tests -nomake examples -no-compile-examples \
 -gif \
 -cups \
 -gtk \
 -qt-doubleconversion \
 -qt-pcre             \
 -qt-zlib             \
 -fontconfig          \
 -qt-harfbuzz         \
 -qt-libpng           \
 -qt-libjpeg          \
 -qt-sqlite           \
 -qt-assimp           \
 -qt-xcb              \
 -qt-webengine-icu    \
 -qt-webengine-ffmpeg \
 -qt-webengine-opus   \
 -qt-webengine-webp   \
 -qt3d-simd avx2 \
$@
