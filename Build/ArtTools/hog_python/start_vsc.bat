@ECHO OFF
REM
REM Starts VScode from this project directory
REM Within a configured ENV for Bluepoint python Tools

TITLE CP13 BP ArtTools HOG_python VScode Workspace
::COLOR 1e

:: Keep changes local
SETLOCAL EnableDelayedExpansion

:: Store current dir
PUSHD %~dp0

:: user override these in "env\set_HOG_user_dev_env.cmd"
:: we are forcing them on to improve troubleshooting going into IDE
IF "%HOG_GLOBAL_DEBUG%"=="" ( SET "HOG_GLOBAL_DEBUG=1" )
IF "%HOG_PY_LOGLEVEL%"=="" ( SET "HOG_PY_LOGLEVEL=10" )
IF "%HOG_PY_EARLY_DEBUG%"=="" ( SET "HOG_PY_EARLY_DEBUG=1" )
IF "%HOG_PY_SHOW_PATHS%"=="" ( SET "HOG_PY_SHOW_PATHS=0" )
IF "%HOG_PY_DEBUG_VERBOSE%"=="" ( SET "HOG_PY_DEBUG_VERBOSE=1" )
IF "%HOG_PY_DEBUG_PAUSE%"=="" ( SET "HOG_PY_DEBUG_PAUSE=0" )
IF "%HOG_PY_DEBUGGER%"=="" ( SET "HOG_PY_DEBUGGER=debugpy" )
IF "%HOG_PY_USE_VENV%"=="" ( SET "HOG_PY_USE_VENV=1" )
:: enable access to PySide2 (if you run into any conflicts let me know, we can disable by default)
IF "%USE_LOCAL_PYSIDE_ACCESS%"=="" ( SET "USE_LOCAL_PYSIDE_ACCESS=1" )

:: reduces the amount of bpe env performed, keeps game connector from starting
:: as that halts the rest of the local env from performing and properly
:: stating the IDE
IF "%HOG_ENVIRONMENT_ONLY%"=="" ( SET "HOG_ENVIRONMENT_ONLY=1" )
:: bypasses the BPE environment with a local only facsimile
IF "%USE_LOCAL_DEV_ENV_ONLY%"=="" ( SET "USE_LOCAL_DEV_ENV_ONLY=0" )

IF "%HOG_PYTHON_VERSION%"=="" ( SET "HOG_PYTHON_VERSION=3.11.4" )
IF "%PYSIDE_VERSION%"=="" ( SET "PYSIDE_VERSION=6" )

:: Calls the entire HOG_python\env setup
CALL %~dp0hog_python_env.cmd

:: just for IDE only
SET "PYTHONPATH=%HOG_PYTHONTOOLS_PATH%\testing;%PYTHONPATH%"

cd /D %HOG_PYTHONTOOLS_PATH%

SET WORKSPACE_ARG=%*

IF "%WORKSPACE_ARG%"=="" ( SET "WORKSPACE_ARG=HOG_python.code-workspace" )

IF EXIST "%PYTHON%" GOTO END_OF_FILE
ECHO ERROR::  Could not find python executable at %PYTHON%
exit /B 1

:END_OF_FILE
IF "%HOG_PY_SHOW_PATHS%"=="1" ( ECHO     PYTHONPATH=%PYTHONPATH% )

IF "%HOG_PY_USE_VENV%"=="1" ( CALL %HOG_PY_BASE_VENV%\Scripts\activate.bat )

echo.
ECHO Starting:: /HOG_python, VScode Workspace
ECHO.
ECHO      Workspace file: "%WORKSPACE_ARG%"
ECHO      [VSC] HOG_PY_USE_VENV = "%HOG_PY_USE_VENV%"
ECHO      [VSC] PYTHON = "%PYTHON%"
echo.

:: oddball settings, PyLance keeps crashing in VScode IDE this one supposedly will help
SET NODE_OPTIONS="--max-old-space-size=10240"

ECHO Directory: %~dp0
echo.

IF "%HOG_PY_DEBUG_PAUSE%"=="1" ( PAUSE )

:: start vscode while specifying the local project workspace to load
code "%WORKSPACE_ARG%" | exit /B %ERRORLEVEL%

PAUSE

ENDLOCAL

exit /B %ERRORLEVEL%
