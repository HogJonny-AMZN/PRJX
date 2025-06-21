@ECHO OFF
REM
REM This will install python and update packages
REM You may need to run within a Admin elevated CMD

:: Keep changes local
SETLOCAL EnableDelayedExpansion

:: Store current dir
PUSHD %~dp0

:: Always set the Python version
SET "HOG_PYTHON_VERSION=3.9.9"
ECHO Setting HOG_PYTHON_VERSION to %HOG_PYTHON_VERSION%

:: Export to parent environment (this helps with SETLOCAL scopes)
ENDLOCAL & SET "HOG_PYTHON_VERSION=3.9.9"

:END_OF_FILE
:: Set flag so we don't initialize environment twice
SET "HOG_PY_SET_VERSION=1"

:: Return to starting directory
POPD

exit /b 0
