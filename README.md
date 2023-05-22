## Notice

Windows only. It is overwhelming to deal with static libs in Linux.

Before using this docker image, you should switch `Docker Desktop` into windows mode.

## Get the libs

### From github

```bat
docker pull ghcr.io/sgqy/qt-static-lib
```

### Build by yourself

```bat
docker build -t qt-libs .
```

## Use the libs

### In your own docker

```docker
# escape=`
FROM ghcr.io/sgqy/qt-static-lib as libs
FROM mcr.microsoft.com/windows/servercore:ltsc2022
COPY --from=libs C:\openssl C:\
COPY --from=libs C:\qt5 C:\
# ...
```

### In your host

Copy libs into `C:\temp`.

```bat
docker run -v C:\temp:C:\target ghcr.io/sgqy/qt-static-lib:slim
```

You should move libs out of `C:\temp`, to match build prefix.

They should be `C:\openssl-102` and `C:\qt-563`.

## License

Qt is LGPL. Do not use static libraries in proprietary code.

## Legacy build

Switch to `legacy` branch for old build method.
