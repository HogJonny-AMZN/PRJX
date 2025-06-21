@echo OFF

:: Store current directory and change to environment directory so script works in any path.
: Drive will get mapped if executed from UNC share
PUSHD %~dp0

set "DEBUGPY_PORT=5678"

echo Looking for PID using debugpy port ...
echo.
echo "command is: netstat -ano|findstr %DEBUGPY_PORT%"
call netstat -ano|findstr %DEBUGPY_PORT%
echo.

echo Will attempt to find and close for you ...
echo.
echo If this fails you may need to kill it manually
echo you need to kill the pid if it's open [LISTENING]
echo.
echo "command is: taskkill /F /PID XXXX"
echo.

FOR /F "tokens=5 delims= " %%P IN ('netstat -a -n -o ^| findstr :%DEBUGPY_PORT%.*LISTENING') DO TaskKill.exe /F /PID %%P

CALL %windir%\system32\cmd.exe /k %*%

:: END
