# escape=`

### * Check README.md for more details.

### * ###
# * Essential tools.

FROM mcr.microsoft.com/windows/servercore:ltsc2019 as toolchain
SHELL ["cmd.exe", "/S", "/C"]

ENV X_TC=C:\_
ENV X_VS=${X_TC}\vs
ENV X_PY3=${X_TC}\py3
ENV X_GIT=${X_TC}\git
ENV X_PERL=${X_TC}\perl
ENV X_DL=${X_TC}\_

WORKDIR ${X_DL}

RUN `
  curl -SL -o a2.zip https://github.com/aria2/aria2/releases/download/release-1.36.0/aria2-1.36.0-win-64bit-build1.zip && `
  tar -xf a2.zip && copy aria2-1.36.0-win-64bit-build1\aria2c.exe . && `
  aria2c.exe -c -s16 -x16 -o g4w.zip https://github.com/git-for-windows/git/releases/download/v2.40.1.windows.1/MinGit-2.40.1-64-bit.zip && `
  md %X_GIT% && tar -xf g4w.zip -C %X_GIT% && `
  aria2c.exe -c -s16 -x16 -o py3.zip https://www.python.org/ftp/python/3.9.13/python-3.9.13-embed-amd64.zip && `
  md %X_PY3% && tar -xf py3.zip -C %X_PY3% && `
  aria2c.exe -c -s16 -x16 -o perl.zip https://strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-64bit-portable.zip && `
  md %X_PERL% && tar -xf perl.zip -C %X_PERL% && `
  aria2c.exe -c -s16 -x16 -o vs.exe https://aka.ms/vs/17/release/vs_BuildTools.exe && `
  (start /w vs.exe --quiet --wait --norestart --nocache `
    --installPath %X_VS% `
    --add Microsoft.VisualStudio.Component.VC.v141.x86.x64 `
    --add Microsoft.VisualStudio.Component.VC.CMake.Project `
    --add Microsoft.VisualStudio.Component.Windows10SDK.19041 `
    || IF "%ERRORLEVEL%"=="3010" EXIT 0) && `
  cd C:\ && rd /s /q %X_DL%

ENV PATH="${X_GIT}\cmd;${X_PY3};${X_PERL}\perl\bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0;C:\Windows\System32\OpenSSH"

ENV X_DEV_CMD="${X_VS}\VC\Auxiliary\Build\vcvarsall.bat amd64"

ENV X_QT_ROOT=C:\qt-651

ENV X_WS=C:\ws
WORKDIR ${X_WS}

ENTRYPOINT %X_DEV_CMD% && cmd.exe

### * ###
# * Download Qt.

FROM toolchain AS build

COPY *.patch .\
RUN `
  git clone --depth 1 --branch v6.5.1 https://github.com/qt/qt5.git qt && cd qt && `
  git rm qtwayland && `
  git rm qtwebengine && `
  git rm qtwebview && `
  git submodule update --init --depth 1 && `
  cd qtdeclarative && git rm tests/auto/qml/ecmascripttests/test262 && cd .. && `
  cd qtxmlpatterns && git rm tests/auto/3rdparty/testsuites && cd .. && `
  git submodule update --init --recursive --depth 1 && `
  cd qtbase && git apply %X_WS%\qt.patch

# * Build configure.

WORKDIR ${X_WS}\qt\_
RUN %X_DEV_CMD% && `
  ..\configure.bat -prefix %X_QT_ROOT% `
    -static -static-runtime -debug-and-release -gc-binaries `
    -nomake examples -no-feature-androiddeployqt

# * Build Qt.

RUN %X_DEV_CMD% && cmake --build . --parallel
RUN %X_DEV_CMD% && ninja install

### * ###
# * Generate devcontainer.

FROM toolchain AS devenv
COPY --from=build ${X_QT_ROOT} ${X_QT_ROOT}
ENV PATH="${X_QT_ROOT}\bin;${PATH}"
