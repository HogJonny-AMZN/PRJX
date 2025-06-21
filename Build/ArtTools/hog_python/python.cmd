@ECHO OFF
REM
REM This .cmd wraps hog_python virtual environment (.venv) python.exe, within a environment context.
REM This script provides a single python entry point that you can trust is present.

TITLE CP13 HOG ArtTools HOG Python [.venv]: python.cmd
::COLOR 1e

:: Keep changes local
SETLOCAL EnableDelayedExpansion

SET CMD_DIR=%~dp0
SET CMD_DIR=%CMD_DIR:~0,-1%

:: Store current dir
PUSHD %~dp0

:: user override these in "ArtTools\hog_python\\env\set_hog_user_dev_env.cmd"
:: we are forcing them on to improve troubleshooting going into IDE
IF "%HOG_GLOBAL_DEBUG%"=="" ( SET "HOG_GLOBAL_DEBUG=0" )
IF "%HOG_PY_LOGLEVEL%"=="" ( SET "HOG_PY_LOGLEVEL=20" )
IF "%HOG_PY_EARLY_DEBUG%"=="" ( SET "HOG_PY_EARLY_DEBUG=0" )
IF "%HOG_PY_SHOW_PATHS%"=="" ( SET "HOG_PY_SHOW_PATHS=0" )
IF "%HOG_PY_DEBUG_VERBOSE%"=="" ( SET "HOG_PY_DEBUG_VERBOSE=0" )
IF "%HOG_PY_DEBUG_PAUSE%"=="" ( SET "HOG_PY_DEBUG_PAUSE=0" )
IF "%HOG_PY_DEBUGGER%"=="" ( SET "HOG_PY_DEBUGGER=debugpy" )
IF "%HOG_PY_USE_VENV%"=="" ( SET "HOG_PY_USE_VENV=1" )

:: enable access to PySide2 (if you run into any conflicts let me know, we can disable by default)
SET "USE_LOCAL_PYSIDE_ACCESS=1"

IF "%HOG_PYTHON_VERSION%"=="" ( SET "HOG_PYTHON_VERSION=3.11.4" )

:: Calls the entire hog_python\env setup
CALL %~dp0hog_python_env.cmd

cd /D %HOG_PYTHONTOOLS_PATH%

SET PYTHON_ARGS=%*

IF EXIST "%PYTHON%" GOTO END_OF_FILE
ECHO      [PYCMD] ERROR  ::  Could not find python executable at %PYTHON%
ECHO      [PYCMD] WARNING::  Make sure python base or .venv is installed
ECHO      [PYCMD] RUN    ::  scripts/get_python.bat
PAUSE
exit /B 1

:END_OF_FILE
IF "%HOG_PY_DEBUG_VERBOSE%"=="1" (
   GOTO hog_python_debug_start
) ELSE (
   GOTO run_dmc
)

:hog_python_debug_start
REM enable these lines to troubleshoot if directory changes are correct
:: ECHO	CWD = %CMD_DIR%
:: ECHO	Input args = %*%

echo Initializing::  %CMD_DIR%\python.cmd
echo.
ECHO      [PYCMD] HOG_ROOT = %HOG_ROOT%
ECHO      [PYCMD] HOG_ARTTOOLS_PATH = %HOG_ARTTOOLS_PATH%
ECHO      [PYCMD] HOG_PYTHONTOOLS_PATH = %HOG_MAYATOOLS_PATH%
echo.
ECHO      [PYCMD] HOG_GLOBAL_DEBUG = %HOG_GLOBAL_DEBUG%
ECHO      [PYCMD] HOG_PY_EARLY_DEBUG = %HOG_PY_EARLY_DEBUG%
ECHO      [PYCMD] HOG_PY_DEBUG_VERBOSE = %HOG_PY_DEBUG_VERBOSE%
ECHO      [PYCMD] HOG_PY_DEBUG_PAUSE = %HOG_PY_DEBUG_PAUSE%
ECHO      [PYCMD] HOG_PY_LOGLEVEL = %HOG_PY_LOGLEVEL%
echo.
ECHO      [PYCMD] HOG_PYTHON_VERSION = Python-%HOG_PYTHON_VERSION%
ECHO      [PYCMD] HOG_PY_BASE_INSTALL = %HOG_PY_BASE_INSTALL%
ECHO      [PYCMD] HOG_PY_BASE_PYTHON_EXE = %HOG_PY_BASE_PYTHON_EXE%
ECHO      [PYCMD] HOG_PY_BASE_PYTHON_PIP = %HOG_PY_BASE_PYTHON_PIP%
echo.
ECHO      [PYCMD] HOG_PY_BASE_VENV = %HOG_PY_BASE_VENV%
ECHO      [PYCMD] HOG_PY_BASE_VENV_EXE = %HOG_PY_BASE_VENV_EXE%
ECHO      [PYCMD] HOG_PY_BASE_VENV_PIP = %HOG_PY_BASE_VENV_PIP%
ECHO      [PYCMD] HOG_PY_SHARED_3P_SITE = %HOG_PY_SHARED_3P_SITE%
echo.
ECHO      [PYCMD] python = "%PYTHON%"
echo.
ECHO      CWD  :: %~dp0
ECHO      Start:: "%PYTHON%"
ECHO      ARGS :: %PYTHON_ARGS%
echo.

IF %HOG_PY_SHOW_PATHS%==1 ( ECHO     PYTHONPATH=%PYTHONPATH% )

:run_dmc
IF "%HOG_PY_USE_VENV%"=="1" ( CALL %HOG_PY_BASE_VENV%\Scripts\activate.bat )

:: Return to previous directory
POPD %~dp0

SET PYTHONNOUSERSITE=1

IF "%HOG_PY_DEBUG_PAUSE%"=="1" ( PAUSE )

:: Run local Python with arguments, example:
::>cd ArtTools\hog_python
::>python -m scripts\some_test.py
"%PYTHON%" %PYTHON_ARGS%

ENDLOCAL

exit /B %ERRORLEVEL%
