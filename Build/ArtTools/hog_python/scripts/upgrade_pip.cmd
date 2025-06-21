@ECHO OFF
REM this will use hython to freeze requirements

:: Keep changes local
SETLOCAL EnableDelayedExpansion

:: Store current dir
PUSHD %~dp0

ECHO Starting: %~dp0upgrade_pip.bat

IF "%HOG_PYTHON_VERSION%"=="" ( SET "HOG_PYTHON_VERSION=3.11.4" )

CALL %~dp0../hog_python_env.cmd

REM Is Blender installed?
echo Verifying python [not .venv] ...
echo.
CALL "%HOG_PY_BASE_PYTHON_EXE%" --version > NUL
IF !ERRORLEVEL!==0 (
    echo      [BLNDR] upgrade_pip.cmd: Python base %HOG_PYTHON_VERSION% is installed
    CALL "%HOG_PY_BASE_PYTHON_EXE%" --version
)
SET "PYTHONNOUSERSITE=1"

ECHO    upgrade_pip.cmd::  Calling ensurepip on base python...
CALL "%HOG_PY_BASE_PYTHON_EXE%" -m ensurepip
IF ERRORLEVEL 1 (
    echo        ERROR: Unable to complete ensurepip.
    echo        You may need to run from an elevated prompt.
    echo        See log above.
    EXIT /b 1
)

REM update pip to latest version (+ setuptools)
echo Updating pip for /hog_python ...
echo.
CALL "%HOG_PY_BASE_PYTHON_EXE%" -m pip install --upgrade pip
if ERRORLEVEL 1 (
    ECHO ERROR: Unable to install pip.
    ECHO You may need to run from an elevated prompt.
    ECHO See log above.
    EXIT /b 1
)
