..\configure.bat -prefix D:\libqt ^
          -debug-and-release -confirm-license -opensource -static -mp ^
          -target xp -no-directwrite -opengl desktop -no-angle ^
          -nomake examples -nomake tests -no-compile-examples -skip qtwebkit ^
          -qt-zlib -qt-libpng -qt-libjpeg -qt-pcre -qt-freetype -qt-harfbuzz ^
          -no-sse3 -no-ssse3 -no-sse4.1 -no-sse4.2 -no-avx -no-avx2 ^
          -openssl-linked OPENSSL_LIBS="-lssleay32 -llibeay32 -lgdi32" ^
          %1