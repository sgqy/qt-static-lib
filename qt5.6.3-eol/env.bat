@rem Reset %PATH% and call devenv settings
set PATH=C:\Windows;C:\Windows\system32
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsamd64_x86.bat"

@rem Set Windows XP SDK
SET PATH=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Bin;%PATH%
SET INCLUDE=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include;%INCLUDE%
SET LIB=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib;%LIB%

@rem Set Perl and Python path
SET PATH=C:\Perl64\perl\bin;C:\Python27;%PATH%

@rem Add OpenSSL to build environment
set INCLUDE=D:\libopenssl\include;%INCLUDE%
set LIB=D:\libopenssl\lib;%LIB%

@rem Just use 2015 when compile Qt5.6 with newer version
set QMAKESPEC=win32-msvc2015

set CL=/FS /utf-8 -D_USING_V110_SDK71_