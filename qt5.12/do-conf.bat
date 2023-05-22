..\configure.bat -prefix D:\libqt ^
          -debug-and-release -confirm-license -opensource -static -mp -silent ^
          -nomake examples -nomake tests -no-compile-examples ^
          -qt-zlib -qt-libpng -qt-libjpeg -qt-pcre -qt-freetype -qt-harfbuzz -qt-sqlite -qt-tiff -qt-webp -qt-assimp -qt3d-simd sse2 ^
          -no-sse3 -no-ssse3 -no-sse4.1 -no-sse4.2 -no-avx -no-avx2 -no-avx512 ^
          -openssl-linked OPENSSL_LIBS="-llibcrypto -llibssl -lWs2_32 -lUser32 -lAdvapi32 -lCrypt32" ^
          %1
