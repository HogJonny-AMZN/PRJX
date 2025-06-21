@ECHO OFF
REM
REM This will install python and update packages
REM You may need to run within a Admin elevated CMD
REM If python is not installed it will install via chocolatey (choco)
REM If choco is not installed it will perform the install
REM Notice: If choco was not installed:
REM  - it will install choco
REM  - Then may fail to proceed, you may need to restart CMD
REM  - And then run this .bat file gain to proceed

SET CMD_DIR=%~dp0
SET CMD_DIR=%CMD_DIR:~0,-1%

:: Store current dir
PUSHD %~dp0

IF "%HOG_PY_VERSION_MAJOR%"=="" ( set "HOG_PY_VERSION_MAJOR=3" )

IF "%HOG_PYTHON_VERSION%"=="" ( SET "HOG_PYTHON_VERSION=3.11.4" )

:: Local BPE ArtTools\HOG_python core ENV
CALL %~dp0..\env\set_HOG_py_init_env.cmd
IF EXIST %HOG_PYTHONTOOLS_PATH%\env\set_HOG_user_dev_env.cmd call %HOG_PYTHONTOOLS_PATH%\env\set_HOG_user_dev_env.cmd
CALL %HOG_PYTHONTOOLS_PATH%\env\set_HOG_py_env.cmd

REM paths, many reusable ones are defined in: hog_python_envbat
REM This Section ECHO's for out HOG_python
:HOG_get_py_debug_start
echo Continuing::  %HOG_PYTHONTOOLS_PATH%\scripts\get_python.cmd
echo     [BASE] HOG_PY_BASE_INSTALL = %HOG_PY_BASE_INSTALL%
echo     [BASE] HOG_PY_BASE_PYTHON_EXE = %HOG_PY_BASE_PYTHON_EXE%
echo     [BASE] HOG_PY_BASE_PYTHON_PIP = %HOG_PY_BASE_PYTHON_PIP%
echo     [BASE] HOG_PY_BASE_VENV_EXE = %HOG_PY_BASE_VENV_EXE%
echo     [BASE] HOG_PY_BASE_VENV_PIP = %HOG_PY_BASE_VENV_PIP%
echo     [BASE] HOG_PY_SHARED_3P_SITE = %HOG_PY_SHARED_3P_SITE%
echo      DONE
echo.

REM General strategy: Check if python is already installed
REM If not, use chocolatey to install it
REM Then ensure pip, update pip, and install requirements

REM Is python installed?
cd /D %HOG_PYTHONTOOLS_PATH%
echo verifying `base` python [not .venv] ...
CALL %HOG_PY_BASE_PYTHON_EXE% --version > NUL
IF !ERRORLEVEL!==0 (
    echo get_python.bat: Python .venv is already installed:
    CALL python.cmd --version
    GOTO install_HOG_base_pip
)

REM is choco installed?
echo verifying choco ...
CALL choco > NUL
IF !ERRORLEVEL!==0 (
    echo get_python.bat: choco is already installed:
    CALL choco
    GOTO install_HOG_base_python
)

REM install chocolatey
echo calling cmd to install chocolatey ...
CALL scripts\install_chocolately.cmd
choco source add -n chocolatey -s 'https://chocolatey.org/api/v2/'
if ERRORLEVEL 1 (
    ECHO ERROR: Unable to install chocolatey.
    ECHO You may need to run from an elevated prompt.
    ECHO See log above.
    EXIT /b 1
)

IF %HOG_PY_DEBUG_PAUSE%==1 ( PAUSE )

set "HOG_PY_REQUIREMENTS=%HOG_PYTHONTOOLS_PATH%\shared"
set "HOG_PY_REQUIREMENTS_GUI=%HOG_PY_REQUIREMENTS%\requirements-%HOG_PYTHON_VERSION%-gui.txt"
set "HOG_PY_REQUIREMENTS_CORE=%HOG_PY_REQUIREMENTS%\requirements-%HOG_PYTHON_VERSION%-core.txt"
set "HOG_PY_REQUIREMENTS_FROZEN=%HOG_PY_REQUIREMENTS%\requirements-%HOG_PYTHON_VERSION%-frozen.txt"
set "HOG_PY_REQUIREMENTS_3P=%HOG_PY_REQUIREMENTS%\requirements-%HOG_PYTHON_VERSION%.txt"

:install_HOG_base_python
REM install base python via chocolatey using HOG_PYTHON_VERSION
echo calling choco to install `base` python [not .venv] ...
echo     HOG_PY_BASE_INSTALL = %HOG_PY_BASE_INSTALL%
set "choco_cmd=choco install python%HOG_PY_VERSION_MAJOR% --version=%HOG_PYTHON_VERSION% -y --params /InstallDir:%HOG_PY_BASE_INSTALL%"
ECHO %choco_cmd%
%choco_cmd%
if ERRORLEVEL 1 (
    ECHO ERROR: Unable to install `base` python via choco.
    ECHO You may need to run from an elevated prompt.
    ECHO See log above.
    EXIT /b 1
)

IF %HOG_PY_DEBUG_PAUSE%==1 ( PAUSE )

:install_HOG_base_pip
REM make sure pip exists in the Python install (so we can install packages)
echo Calling ensurepip on `base` python [not .venv] ...
CALL %HOG_PY_BASE_PYTHON_EXE% -m ensurepip
if ERRORLEVEL 1 (
    ECHO ERROR: Unable to install pip on `base`.
    ECHO You may need to run from an elevated prompt.
    ECHO See log above.
    EXIT /b 1
)

:update_HOG_base_pip
REM update pip to latest version (+ setuptools)
echo Updating pip on `base` python [not .venv] ...
CALL %HOG_PY_BASE_PYTHON_EXE%  -m pip install --upgrade pip
if ERRORLEVEL 1 (
    ECHO ERROR: Unable to install pip.
    ECHO You may need to run from an elevated prompt.
    ECHO See log above.
    EXIT /b 1
)

:install_HOG_py_base_venv
REM sets up the install of a base VENV for the default Python version (not virtualenv)
echo Installing python virtual environment "%HOG_PY_BASE_VENV%"
CALL "%HOG_PY_BASE_PYTHON_EXE%" -m venv "%HOG_PY_BASE_VENV%"
if ERRORLEVEL 1 (
    ECHO ERROR: Unable to create Python VENV ...
    ECHO You may need to run from an elevated prompt.
    ECHO See log above.
    EXIT /b 1
)

:update_HOG_py_base_venv_pip
REM update pip to latest version (+ setuptools)
echo Updating pip for python .venv ...
CALL "%HOG_PY_BASE_VENV_EXE%" -m pip install --upgrade pip
if ERRORLEVEL 1 (
    ECHO ERROR: Unable to install pip.
    ECHO You may need to run from an elevated prompt.
    ECHO See log above.
    EXIT /b 1
)

CALL %CMD_DIR%\update_python_core_packages.cmd

:install_HOG_py_base_venv_packages_gui
REM install the root requirements-gui.txt into the %HOG_PY_BASE_VENV%
echo Calling PIP to install requirements-gui.txt into .venv ...
echo     Into VENV: %HOG_PY_BASE_VENV%\Lib\site-packages
call "%HOG_PY_BASE_VENV_PIP%" install -r "%HOG_PY_REQUIREMENTS_GUI%" --disable-pip-version-check --no-warn-script-location
if ERRORLEVEL 1 (
    echo Failed installing requirements into the Python .venv ...
    echo Failed to install the packages listed in %HOG_PY_REQUIREMENTS_GUI%.  Check the log above!
    EXIT /b 1
)

CALL %CMD_DIR%\update_python_packages.cmd

:HOG_py_base_venv_pip_freeze
ECHO Setting up local .pth for site-packages ...
:: "D:\dev\CP13\Build\ArtTools\HOG_python\shared\Python-3.10\HOG_venv-3.10.pth.example.txt"
xcopy "%HOG_PY_SHARED_3P%\Python-%HOG_PYTHON_VERSION%\HOG_venv-%HOG_PYTHON_VERSION%.pth.example.txt" "%HOG_PY_BASE_VENV%\Lib\site-packages\HOG_venv.pth" /y /v /f /r
IF ERRORLEVEL 1 (
    echo        "ERROR: Unable to copy .pth file into venv"
    echo        You may need to run from an elevated prompt.
    echo        See log above.
    EXIT /b 1
)

:HOG_py_base_venv_pip_freeze
REM this will use PIP in the VENV to freeze a requirements.txt (so we can pulled versioned packages up out of venv)
echo Calling PIP to freeze VENV requirements.txt ...
echo     Into: %HOG_PY_REQUIREMENTS_FROZEN%
call "%HOG_PY_BASE_VENV_PIP%" freeze > "%HOG_PY_REQUIREMENTS_FROZEN%"
if ERRORLEVEL 1 (
    echo Failed to PIP freeze requirements.  Check the log above!
    echo into: "%HOG_PY_REQUIREMENTS_FROZEN%"
    EXIT /b 1
)

REM we could also install our package(s) directly into python, to work with additional scripts/modules
@REM call "%CMD_DIR%\pip.cmd" install -e "%CMD_DIR%\Scripts\bpe" --disable-pip-version-check --no-warn-script-location --no-deps
@REM if ERRORLEVEL 1 (
@REM     echo Failed to install %CMD_DIR%\Scripts\bpe into python.  Check the log above!
@REM     EXIT /b 1
@REM )

:END_OF_FILE

PAUSE

:: Return to starting directory
POPD

cd /d %HOG_PYTHONTOOLS_PATH%

exit /b 0
