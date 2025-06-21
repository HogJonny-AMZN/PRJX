@ECHO OFF
REM
REM opens a cmd with debugger copnnection message
:: To do: maybe make a standalone PySide message box instead?

:: Keep changes local
SETLOCAL EnableDelayedExpansion

:: Store current dir
PUSHD %~dp0

SET "HOG_PY_DEBUG_VERBOSE=0"

CALL %~dp0..\env\set_HOG_py_env.cmd

if "%HOG_PY_EARLY_DEBUG%"=="1" ( ECHO BP Python developer environment, envar HOG_PY_EARLY_DEBUG is: %HOG_PY_EARLY_DEBUG% )
echo.
ECHO Attempting to WAIT for IDE debug client attachment. [ User should form attachment from IDE ]
ECHO This is a blocking call, to give the User time to form the debugpy connection, instructions below.
echo.
ECHO Recommended steps:
ECHO     1. To start the VSC workspace for debugging, double-click the .bat file: `start_vsc.bat`
ECHO     2. VScode [ menubar ] :: View :: Run : will open the 'Run and Debug' panel in VScode
ECHO     3. Use the 'Run and Debug' pulldown, select: 'Attach Debugpy'
ECHO     4. Use the 'green play arrow' next to pulldown to ititiate a connection
ECHO     5. This cmd messagebox you are reading, must be closed before the connection can finish.
echo.

PAUSE

ENDLOCAL

exit
