@ECHO OFF
REM
REM Tests the attach debugpy functionality in a standalone cmd console

TITLE CP13 BP ArtTools Maya VScode
::COLOR 1e

:: Keep changes local
SETLOCAL EnableDelayedExpansion

SET CMD_DIR=%~dp0

IF "%HOG_ENVIRONMENT_ONLY%"=="" ( SET "HOG_ENVIRONMENT_ONLY=1" )
:: bypasses the BPE environment with a local only facsimile
IF "%USE_LOCAL_DEV_ENV_ONLY%"=="" ( SET "USE_LOCAL_DEV_ENV_ONLY=1" )

:: Calls the entire HOG_python\env setup
CALL %CMD_DIR%\..\hog_python_envcmd

CALL "%PYTHON%" "%HOG_PY_PACKAGES%\HOG_py\lib\HOG_dev\debug.py"

PAUSE