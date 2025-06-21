@echo off
REM Cmd prompt initialized with environment variables

TITLE CP13 HOG ArtTools Python: hog_cmd.cmd
::COLOR 1e

:: Keep changes local
SETLOCAL EnableDelayedExpansion

:: Store current dir
PUSHD %~dp0

:: Create command prompt with environment
ECHO Hogwarts ./hog_cmd.cmd

SET "HOG_PY_DEBUG_VERBOSE=1"
SET "HOG_PY_USE_VENV=1"

:: enable access to PySide2 (if you run into any conflicts let me know, we can disable by default)
SET "USE_LOCAL_PYSIDE_ACCESS=1"

IF "%HOG_PYTHON_VERSION%"=="" ( SET "HOG_PYTHON_VERSION=3.11.4" )

:: Calls the entire hog_python\env setup
CALL %~dp0hog_python_env.cmd

IF "%HOG_PY_DEBUG_VERBOSE%"=="1" (
   GOTO debug_args
) ELSE (
   GOTO run_dmc
)

:debug_args
REM enable these lines to troubleshoot if directory changes are correct
:: ECHO	CWD = %HOG_PYTHONTOOLS_PATH%
:: ECHO	Input args = %*%

:run_dmc
:: Return to starting directory
POPD

IF "%HOG_PY_SHOW_PATHS%"=="1" (
   ECHO PYTHONPATH=%PYTHONPATH%
   echo.
)

cd /d %HOG_PYTHONTOOLS_PATH%

IF "%HOG_PY_USE_VENV%"=="1" ( CALL %HOG_PY_BASE_VENV%\Scripts\activate.bat )

CALL %windir%\system32\cmd.exe /k %*%
IF !ERRORLEVEL!==0 (
    GOTO END_OF_FILE
) ELSE (
   GOTO hog_cmd_error
)

:hog_cmd_error
exit /B %ERRORLEVEL%

:END_OF_FILE

ENDLOCAL
