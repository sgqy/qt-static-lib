## Notice

Windows only. It is overwhelming to deal with static libs in Linux.

Before using this docker image, you should switch `Docker Desktop` into windows mode.

## Get the libs

### From github

```cmd
docker pull ghcr.io/sgqy/qt-static-lib:v6.5.1
```

### Build by yourself

Will take about 200GB disk space. 18 hours on i7-8750H (Docker only use half CPU default).

```ps1
# with also install build toolchain
docker build --target devenv -t qt:devenv .
```

## Use the libs

### In your own docker

```docker
# escape=`
FROM ghcr.io/sgqy/qt-static-lib:v6.5.1 as toolchain
# Make your app
```

### In your host

Copy libs into `C:\temp`.

```cmd
docker run -v C:\temp:C:\target ghcr.io/sgqy/qt-static-lib:v6.5.1
xcopy C:\qt-651 C:\target\qt-651 /E /H /C /I /R /Y /G /Q
```

You should move libs out of `C:\temp`, to match build prefix.

They should be `C:\qt-651`.

## License

Qt is LGPL. Do not use static libraries in proprietary code.

## Legacy build

Switch to `legacy` branch for old build method.
