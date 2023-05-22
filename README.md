## Notice

Windows only. It is overwhelming to deal with static libs in Linux.

Before using this docker image, you should switch `Docker Desktop` into windows mode.

## Get the libs

### From github

```cmd
docker pull ghcr.io/sgqy/qt-static-lib:devenv
```

### Build by yourself

```ps1
# only libs
docker build --target slim -t qt:slim .
# with msvc
docker build --target devenv -t qt:devenv .
```

## Use the libs

### In your own docker

```docker
# escape=`
FROM ghcr.io/sgqy/qt-static-lib:devenv as toolchain
# Make your app
```

### In your host

Copy libs into `C:\temp`.

```cmd
docker run -v C:\temp:C:\target ghcr.io/sgqy/qt-static-lib:slim
```

You should move libs out of `C:\temp`, to match build prefix.

They should be `C:\openssl-102` and `C:\qt-563`.

## License

Qt is LGPL. Do not use static libraries in proprietary code.

## Legacy build

Switch to `legacy` branch for old build method.
