# Build steps

## Build OpenSSL 1.1.1

Call environment file `env.bat`.

```batchfile
perl Configure no-shared no-asm --prefix=D:\libopenssl --openssldir=D:\libopenssl VC-WIN32

nmake
nmake install_sw
```

If you use `jom`.

```batchfile
jom
jom install_sw
```

### Prepare Qt source code

Use **Git for Windows** to download source code.

```shell
git clone https://code.qt.io/qt/qt5.git qt5

cd qt5

git checkout v5.12.5

perl init-repository --module-subset=default,-qtwebkit,-qtwebkit-examples,-qtwebengine -f
```

Apply `msvc-desktop.conf.static.patch` to
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

If you use `jom`.

```batchfile
jom
jom install
```
