# Build steps

## Build OpenSSL 1.0.2

Apply `VC-32.pl.winxp.path` to `util/pl/VC-32.pl`.

Call environment file `env.bat`.

```batchfile
perl Configure no-shared no-asm --prefix=D:\libopenssl --openssldir=D:\libopenssl VC-WIN32

ms\do_ms.bat

nmake -f ms\nt.mak
nmake -f ms\nt.mak install
```

If you use `jom`, make a folder first (maybe a bug in Makefile).

```batchfile
mkdir inc32\openssl
jom -f ms\nt.mak
```

### Prepare Qt source code

Use **Git for Windows** to download source code.

```shell
git clone https://code.qt.io/qt/qt5.git qt5

cd qt5

git checkout v5.8.0
cp init-repository ../

git checkout v5.6.3
mv ../init-repository .

perl init-repository --module-subset=default,-qtwebkit,-qtwebkit-examples,-qtwebengine -f
```

Apply `msvc-desktop.conf.winxp.patch` to
`qtbase/mkspecs/common/msvc-desktop.conf`.

## Build Qt

Call environment file `env.bat`.

```batchfile
mkdir build
cd build

do-conf.bat
nmake
nmake install
```

If you use `jom`. Set job number to 1 when install or a lot of errors.

```batchfile
jom
jom install -j1
```
