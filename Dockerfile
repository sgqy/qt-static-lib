# escape=`

### * Check README.md for more details.

### * ###

FROM mcr.microsoft.com/windows/servercore:ltsc2019 as toolchain
SHELL ["cmd", "/S", "/C"]

# * Install MSVC toolchain.

ENV MSVC_Root="C:\vs_tools"
RUN `
  curl -SL -o vs.exe https://aka.ms/vs/17/release/vs_BuildTools.exe && `
  (start /w vs.exe --quiet --wait --norestart --nocache `
    --installPath %MSVC_Root% `
    --add Microsoft.VisualStudio.Component.VC.v141.x86.x64 `
    --add Microsoft.Component.VC.Runtime.UCRTSDK `
    --add Microsoft.VisualStudio.Component.WinXP `
    || IF "%ERRORLEVEL%"=="3010" EXIT 0) && `
  del /q vs.exe

# * Qt MSVC toolchain environments.

ENV OpenSSL_102_Root="C:\openssl-102"
ENV Qt563_Root="C:\qt-563"

ENV PATH="C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Bin;${MSVC_Root}\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86;C:\Windows\system32;C:\Windows;C:\Windows\System32\OpenSSH"
ENV INCLUDE="${OpenSSL_102_Root}\include;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include;${MSVC_Root}\VC\Tools\MSVC\14.16.27023\include;C:\Program Files (x86)\Windows Kits\10\Include\10.0.10240.0\ucrt"
ENV LIB="${OpenSSL_102_Root}\lib;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib;${MSVC_Root}\VC\Tools\MSVC\14.16.27023\lib\x86;C:\Program Files (x86)\Windows Kits\10\Lib\10.0.10240.0\ucrt\x86"
ENV CL="/FS /utf-8 -D_USING_V110_SDK71_"
ENV QMAKESPEC="win32-msvc2017"

### * ###

FROM toolchain AS build

# * Install git, qt-jom, perl, python.

ENV _DOWNLOAD="C:\download"
WORKDIR ${_DOWNLOAD}
RUN `
  curl -SL -o g4w.zip https://github.com/git-for-windows/git/releases/download/v2.40.1.windows.1/MinGit-2.40.1-64-bit.zip && `
  curl -SL -o jom.zip https://download.qt.io/official_releases/jom/jom_1_1_3.zip && `
  curl -SL -o perl.zip https://strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-64bit-portable.zip && `
  curl -SL -o py.zip https://www.python.org/ftp/python/3.9.13/python-3.9.13-embed-amd64.zip

RUN `
  md C:\git && cd /D C:\git && tar -xf %_DOWNLOAD%\g4w.zip && `
  md C:\jom && cd /D C:\jom && tar -xf %_DOWNLOAD%\jom.zip && `
  md C:\perl && cd /D C:\perl && tar -xf %_DOWNLOAD%\perl.zip && `
  md C:\py39 && cd /D C:\py39 && tar -xf %_DOWNLOAD%\py.zip

# * Set build environments.

ENV DEV_PATH="C:\git\cmd;C:\py39;C:\jom;C:\perl\perl\bin"
ENV PATH="${DEV_PATH};${PATH}"

# * Start build.

ENV _WORKSPACE="C:\workspace"
WORKDIR ${_WORKSPACE}
COPY *.patch .\

# - OpenSSL 1.0.2u

# mkdir manually before jom, which is a bug of jom
RUN `
  git clone --depth 1 --branch OpenSSL_1_0_2u https://github.com/openssl/openssl.git ossl && `
  cd ossl && `
  git apply ..\openssl.patch && `
  perl Configure no-shared no-asm --prefix=%OpenSSL_102_Root% --openssldir=%OpenSSL_102_Root% VC-WIN32 && `
  ms\do_ms.bat && `
  md inc32\openssl && `
  jom -f ms\nt.mak && `
  nmake -f ms\nt.mak install

# - Qt 5.6.3

# do not build web browser
RUN `
  git clone --depth 1 --branch v5.6.3 https://github.com/qt/qt5.git qt5 && `
  cd qt5 && `
  copy .gitmodules ..\ && `
  git rm qtandroidextras    && md qtandroidextras && `
  git rm qtmacextras        && md qtmacextras && `
  git rm qtwayland          && md qtwayland && `
  git rm qtwebengine        && md qtwebengine && `
  git rm qtwebkit           && md qtwebkit && `
  git rm qtwebkit-examples  && md qtwebkit-examples && `
  git submodule update --init --depth 1 && `
  copy /Y ..\.gitmodules . && `
  cd qtbase && `
  git apply ..\..\qt.patch

WORKDIR ${_WORKSPACE}\qt5\build
RUN `
  ..\configure.bat -prefix %Qt563_Root% `
    -debug-and-release -confirm-license -opensource -static -mp `
    -target xp -no-directwrite -opengl desktop -no-angle `
    -nomake examples -nomake tests -no-compile-examples `
    -skip qtandroidextras `
    -skip qtmacextras `
    -skip qtwayland `
    -skip qtwebkit `
    -qt-zlib -qt-libpng -qt-libjpeg -qt-pcre -qt-freetype -qt-harfbuzz `
    -no-sse3 -no-ssse3 -no-sse4.1 -no-sse4.2 -no-avx -no-avx2 `
    -openssl-linked OPENSSL_LIBS="-lssleay32 -llibeay32 -lgdi32"

# retry max 5 times, for some strange file not found error.
RUN jom || jom || jom || jom || jom
RUN jom install -j1

# * Save build artifacts.

FROM mcr.microsoft.com/windows/nanoserver:ltsc2019 AS slim
COPY --from=build ${Qt563_Root} ${OpenSSL_102_Root} C:\

FROM toolchain AS default
COPY --from=build ${Qt563_Root} ${OpenSSL_102_Root} C:\
