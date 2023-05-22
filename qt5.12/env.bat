@rem Reset %PATH% and call devenv settings
set PATH=C:\Windows;C:\Windows\system32
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsamd64_x86.bat"

@rem Set Perl and Python path
SET PATH=C:\Perl64\perl\bin;C:\Python37;%PATH%

@rem Add OpenSSL to build environment
set INCLUDE=D:\libopenssl\include;%INCLUDE%
set LIB=D:\libopenssl\lib;%LIB%

set CL=/FS /utf-8