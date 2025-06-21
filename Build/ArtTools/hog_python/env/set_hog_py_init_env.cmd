@ECHO OFF
REM
:: Initialize BP ArtTools core environment [ for python developers ]

SET CMD_DIR=%~dp0
SET CMD_DIR=%CMD_DIR:~0,-1%

:: Store current dir
PUSHD %~dp0

:: Skip initialization if already completed
IF "%HOG_PY_INIT_ENV%"=="1" GOTO :END_OF_FILE

IF "%HOG_PY_DEBUG_VERBOSE%"=="" ( SET "HOG_PY_DEBUG_VERBOSE=0" )

REM Everything relies on HOG_ROOT
:: Change to root dir
CD /d %~dp0..\..\..\..\
:: Write root directory to main HOG_ROOT env var
FOR /f "tokens=1" %%B in ('CHDIR') do set HOG_ROOT=%%B
:: Strip trailing backspace
IF "%HOG_ROOT:~-1%"=="\" SET HOG_ROOT=%HOG_ROOT:~0,-1%
CD /d %~dp0

:: required base to get anywhere
CALL %~dp0set_hog_base_init_env.cmd
:: ECHO HOG_ROOT = %HOG_ROOT%
:: ECHO HOG_ARTTOOLS_PATH = %HOG_ARTTOOLS_PATH%
:: ECHO HOG_PYTHONTOOLS_PATH = %HOG_PYTHONTOOLS_PATH%

REM Set the default Python version to install (can later be overwritten procedurally)
:: this also allows it to be set in a launcher or from cli before this .cmd is called

CALL %~dp0..\env\set_version.cmd

IF "%PYSIDE_VERSION%"=="" ( SET "PYSIDE_VERSION=6" )

IF "%HOG_PY_BASE%"=="" ( SET "HOG_PY_BASE=%HOG_PYTHONTOOLS_PATH%\base" )
IF "%HOG_PYTHON_VERSION%"=="" (
  ECHO Error: HOG_PYTHON_VERSION is not set. Make sure set_version.cmd is called first.
  EXIT /b 1
)
IF "%HOG_PY_BASE_INSTALL%"=="" ( SET "HOG_PY_BASE_INSTALL=%HOG_PY_BASE%\Python-%HOG_PYTHON_VERSION%" )
SET "HOG_PY_BASE_PYTHON_EXE=%HOG_PY_BASE_INSTALL%\python.exe"
SET "HOG_PY_BASE_PYTHON_PIP=%HOG_PY_BASE_INSTALL%\scripts\pip3.exe"

:: Force usage of the correct Python version for venv
ECHO [DEBUG] Setting venv path for Python-%HOG_PYTHON_VERSION%
SET "HOG_PY_BASE_VENV=%HOG_PYTHONTOOLS_PATH%\.venv\Python-%HOG_PYTHON_VERSION%"
SET "HOG_PY_BASE_VENV_EXE=%HOG_PY_BASE_VENV%\scripts\python.exe"
SET "HOG_PY_BASE_VENV_PIP=%HOG_PY_BASE_VENV%\scripts\pip.exe"

:: Debug check for Python base directory existence
IF NOT EXIST "%HOG_PY_BASE%" (
    IF "%HOG_PY_DEBUG_VERBOSE%"=="1" (
        ECHO      [INIT] WARNING: Base directory %HOG_PY_BASE% does not exist. Will be created during Python installation.
    )
)

:: Debug check for venv directory
IF NOT EXIST "%HOG_PY_BASE_VENV%" (
    IF "%HOG_PY_DEBUG_VERBOSE%"=="1" (
        ECHO      [INIT] WARNING: Virtual environment %HOG_PY_BASE_VENV% does not exist. Will need to be created.
    )
)

SET "HOG_PY_SHARED_3P=%HOG_PYTHONTOOLS_PATH%\shared"
SET "HOG_PY_REQUIREMENTS=%HOG_PYTHONTOOLS_PATH%\shared\requirements"

IF "%HOG_PY_DEBUG_VERBOSE%"=="1" (
   GOTO hog_py_init_debug_start
) ELSE (
   GOTO END_OF_FILE
)

:hog_py_init_debug_start
echo.
ECHO Initializing::  %~dp0set_hog_py_init_env.cmd
ECHO      [INIT] HOG_PYTHON_VERSION = %HOG_PYTHON_VERSION%
ECHO      [INIT] HOG_PY_BASE = %HOG_PY_BASE%
ECHO      [INIT] HOG_PY_BASE_INSTALL = %HOG_PY_BASE_INSTALL%
ECHO      [INIT] HOG_PY_BASE_PYTHON_EXE = %HOG_PY_BASE_PYTHON_EXE%
echo.
ECHO      [INIT] HOG_PY_BASE_VENV = %HOG_PY_BASE_VENV%
ECHO      [INIT] HOG_PY_BASE_VENV_EXE = %HOG_PY_BASE_VENV_EXE%
ECHO      [INIT] HOG_PY_BASE_VENV_PIP = %HOG_PY_BASE_VENV_PIP%
echo.
ECHO      [INIT] HOG_PY_SHARED_3P = %HOG_PY_SHARED_3P%
echo.
ECHO       DONE
echo.

:END_OF_FILE
:: Set flag so we don't initialize environment twice
SET "HOG_PY_INIT_ENV=1"

:: Return to starting directory
POPD
