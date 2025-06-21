@ECHO OFF
REM
REM HOG initialize Sys PATH for hog_python (development)

:: Store current dir
PUSHD %~dp0

REM Skip initialization if already completed
IF "%HOG_PY_SYS_PATH_ENV%"=="1" GOTO :END_OF_FILE

REM don't duplicate these parts of the ENV, set by:
:: CALL %HOG_ROOT%\Build\Scripts\bpeSetEnv.bat <- we do call this in set_hog_py_env.cmd
CALL %~dp0set_hog_py_env.cmd

:: access to root, non-package utilities and scripts (.bat, .cmd, etc.)
SET "PATH=%HOG_PYTHONTOOLS_PATH%;%HOG_PYTHONTOOLS_PATH%\scripts;%HOG_PY_BASE_VENV%\scripts;%PATH%"

:: this is for troubleshooting the env initialization, as .cmd/.bat has no debugging capabilities
:: enable in: env\set_hog_user_dev_env.cmd
IF "%HOG_PY_DEBUG_VERBOSE%"=="1" (   echo Initializing::  %~dp0set_hog_python_PATH.cmd
   echo      PATH access DONE
   echo.
)

IF "%HOG_PY_DEBUG_PAUSE%"=="1" ( PAUSE )

:END_OF_FILE

:: Set flag so we don't initialize environment twice
SET "HOG_PY_SYS_PATH_ENV=1"

:: Return to starting directory
POPD
