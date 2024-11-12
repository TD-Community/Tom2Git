@echo off

REM ** Create release ***************************************
REM
REM Builds TOM2Git.exe
REM Copies needed runtime files into folder .\Release
REM
REM **********************************************************

set TDVERSION=TD7.5
set TDEXE=C:\Program Files (x86)\Gupta\Team Developer 7.5\cbi75.exe
set TDINSTALL=C:\Program Files (x86)\Gupta\Team Developer 7.5
set TDREGISTRYLOC=HKCU\Software\Gupta\SQLWindows 7.5\Settings

set APPRUNTIME=C:\DEVELOPMENT\AppRuntime
set SRCFOLDER1=C:\DEVELOPMENT\Sources
set RESFOLDER1=C:\DEVELOPMENT\Resources

set TDREGISTRYVAL=%SRCFOLDER1%;%RESFOLDER1%;%TDINSTALL%

cls
echo ===================================================
echo Preparing %TDVERSION% environment...
echo.
echo ===================================================
echo.

PATH = %TDINSTALL%;%PATH%
PATH = %APPRUNTIME%;%PATH%
PATH = %SRCFOLDER1%;%PATH%
PATH = %RESFOLDER1%;%PATH%

echo Set registry TD IncludePath:
REG ADD "%TDREGISTRYLOC%" /v IncludePath /t REG_SZ /d "%TDREGISTRYVAL%" /f

echo Set registry TD PreferUTF8Encoding to UTF8 read/save:
REG ADD "%TDREGISTRYLOC%" /v PreferUTF8Encoding /t REG_DWORD /d 3 /f

echo.
echo PATH set to:
echo %TDINSTALL%

echo.
echo Extract TD runtime...
powershell -command "Expand-Archive -Force TDRuntime\TDRuntime.zip 'Release\'"

echo Copy extra runtime files...
copy *.dll Release\
copy *.apd Release\
copy *.cfg Release\
copy README.MD Release\Documentation\
xcopy .\Documentation\README.pdf Release\Documentation\README.pdf*
xcopy .\README.md Release\Documentation\README.md*
REM copy sql.ini Release\
robocopy TEMPLATES Release\TEMPLATES /E

echo.
echo Building Tom2Git.exe...
"%TDEXE%" -b TomToGit.apt Release\TomToGit.exe



echo.
pause
