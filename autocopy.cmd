@echo off
cd C:\target
IF EXIST 50e2d7f4-48a4-4688-9ddd-c5fb840e87b2 (
    echo You should mount output folder to C:\target of container.
) ELSE (
    echo Copy build artifacts: OpenSSL 1.0.2
    xcopy C:\openssl-102 openssl-102 /E /H /C /I /R /Y /G /Q
    echo Copy build artifacts: Qt 5.6.3
    xcopy C:\qt-563 qt-563 /E /H /C /I /R /Y /G /Q
)