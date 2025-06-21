@ECHO OFF
REM
REM HOG initialize PYTHONPATH for Python (development)

:: Store current dir
PUSHD %~dp0

REM Skip initialization if already completed
IF "%HOG_PY_PYTHONPATH_ENV%"=="1" GOTO :END_OF_FILE

REM don't duplicate these parts of the ENV, set by:
:: CALL %HOG_ROOT%\Build\Scripts\bpeSetEnv.bat <- we do call this in set_hog_py_env.cmd
CALL %~dp0set_hog_py_env.cmd

:: flag to switch on access to local PySide2 (for standalone gui's)
if "%USE_LOCAL_PYSIDE_ACCESS%"=="1" (
    SET "PYTHONPATH=%HOG_PY_SHARED_3P_GUI_SITE%;%PYTHONPATH%"
)

REM Our HOG General Python path access
SET "PYTHONPATH=%HOG_PY_SHARED_3P_SITE%;%HOG_PYTHONTOOLS_PATH%\scripts;%HOG_PACKAGES%;%HOG_PYTHON_PACKAGES%;%PYTHONPATH%"

:: this is for troubleshooting the env initialization, as .cmd/.bat has no debugging capabilities
:: enable in: env\set_hog_user_dev_env.cmd
IF "%HOG_PY_DEBUG_VERBOSE%"=="1" (
   echo Initializing::  %~dp0set_hog_python_PYTHONPATH.cmd
   echo      PYTHONPATH access DONE
   echo.
)

IF "%HOG_PY_DEBUG_PAUSE%"=="1" ( PAUSE )

:END_OF_FILE

:: Set flag so we don't initialize environment twice
SET "HOG_PY_PYTHONPATH_ENV=1"

:: Return to starting directory
POPD
