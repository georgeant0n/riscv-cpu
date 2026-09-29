@echo off
rem run.bat <name>  -  compile rtl\*.v + tb\<name>_tb.v and run the simulation (no GUI).
rem Example:  sim\run.bat regfile
setlocal EnableDelayedExpansion
if "%~1"=="" (
    echo Usage: run.bat ^<name^>    e.g.  run.bat regfile
    exit /b 1
)
set "VIVADO_BIN=C:\AMDDesignTools\2026.1\Vivado\bin"
set "ROOT=%~dp0.."
set "WORK=%~dp0work"
if not exist "%WORK%" mkdir "%WORK%"

set "FILES="
for %%f in ("%ROOT%\rtl\*.v") do set FILES=!FILES! "%%~ff"

pushd "%WORK%"
call "%VIVADO_BIN%\xvlog.bat" !FILES! "%ROOT%\tb\%~1_tb.v" || goto fail
call "%VIVADO_BIN%\xelab.bat" %~1_tb -s %~1_sim || goto fail
call "%VIVADO_BIN%\xsim.bat" %~1_sim -R || goto fail
popd
exit /b 0

:fail
popd
echo *** simulation flow failed ***
exit /b 1
