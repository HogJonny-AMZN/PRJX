@ECHO OFF
REM
REM This will install python and update packages
REM You may need to run within a Admin elevated CMD

:: Keep changes local
SETLOCAL EnableDelayedExpansion

:: Store current dir
PUSHD %~dp0

ECHO Starting: %~dp0setup_venv.bat

SET "HOG_ENVIRONMENT_ONLY=1"
SET "USE_LOCAL_DEV_ENV_ONLY=1"

CALL %~dp0../env/set_version.cmd

CALL %~dp0../hog_python_env.cmd

IF "%HOG_PY_BASE%"=="" ( SET "HOG_PY_BASE=%HOG_PYTHONTOOLS_PATH%\Base" )
IF "%HOG_PY_BASE_INSTALL%"=="" ( SET "HOG_PY_BASE_INSTALL=%HOG_PY_BASE%\Python-%HOG_PYTHON_VERSION%" )
SET "HOG_PY_BASE_PYTHON_EXE=%HOG_PY_BASE_INSTALL%\python.exe"
SET "HOG_PY_BASE_PYTHON_PIP=%HOG_PY_BASE_INSTALL%\scripts\pip3.exe"

ECHO     [BASE] HOG_PY_BASE_INSTALL = %HOG_PY_BASE_INSTALL%
ECHO     [BASE] HOG_PY_BASE_PYTHON_EXE = %HOG_PY_BASE_PYTHON_EXE%

PAUSE

cd /D %HOG_BLENDER_DEVPY_PATH%

CALL %HOG_BLENDER_DEVPY_PATH%\scripts\upgrade_pip.cmd

ECHO    setup_venv.bat::  Installing: "%HOG_PY_BASE_VENV%" ...
CALL "%HOG_PY_BASE_PYTHON_EXE%" -m venv --copies "%HOG_PY_BASE_VENV%"
IF ERRORLEVEL 1 (
    echo        ERROR: Unable to create Python VENV ...
    echo        You may need to run from an elevated prompt.
    echo        See log above.
    EXIT /b 1
)

IF EXIST "%HOG_PY_BASE_VENV_EXE%" CALL %HOG_PY_BASE_VENV%\Scripts\activate.bat

ECHO    setup_venv.bat::  Calling ensurepip on venv...
CALL "%HOG_PY_BASE_VENV_EXE%" -m ensurepip
IF ERRORLEVEL 1 (
    echo        ERROR: Unable to complete ensurepip.
    echo        You may need to run from an elevated prompt.
    echo        See log above.
    EXIT /b 1
)

ECHO    setup_venv.bat::  Updating venv pip [build, pip] ...
CALL "%HOG_PY_BASE_VENV_EXE%" -m pip install --upgrade pip
IF ERRORLEVEL 1 (
    echo        ERROR: Unable to 'install --upgrade pip '
    echo        You may need to run from an elevated prompt.
    echo        See log above.
    EXIT /b 1
)

REM  BP Blender: the Painter requirements folder
set "HOG_PY_BASE_VENV_REQUIREMENTS_CORE_TXT=%HOG_PY_SHARED_3P%\requirements\requirements-%HOG_PYTHON_VERSION%-core.txt"
ECHO      [BLNDR] HOG_PY_BASE_VENV_REQUIREMENTS_CORE_TXT = %HOG_PY_BASE_VENV_REQUIREMENTS_CORE_TXT%

:install_HOG_blender_venv_packages_standard
REM install the root requirements-core.txt into the %HOG_PY_BASE_VENV%
:: this is a list frozen from Blenders python.exe, our .venv will mimic as much as possible
echo Calling PIP to install `requirements-%HOG_PYTHON_VERSION%-core.txt` into .venv ...
echo     Into VENV: %HOG_PY_BASE_VENV%\Lib\site-packages
echo.
call "%HOG_PY_BASE_VENV_EXE%" -m pip install -r "%HOG_PY_BASE_VENV_REQUIREMENTS_CORE_TXT%" --disable-pip-version-check --no-warn-script-location
if ERRORLEVEL 1 (
    echo Failed Installing requirements into the Python .venv ...
    echo Failed to install the packages listed in %HOG_PY_BASE_VENV_REQUIREMENTS_CORE_TXT%.  Check the log above!
    EXIT /b 1
)

:END_OF_FILE

PAUSE

:: Return to starting directory
POPD

exit /b 0
