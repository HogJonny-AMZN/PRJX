@ECHO OFF
REM
REM This will install/update our base and .venv core python packages

:: Store current dir
PUSHD %~dp0

CALL %~dp0../env/set_version.cmd
ECHO After set_version.cmd: HOG_PYTHON_VERSION=%HOG_PYTHON_VERSION%

:: Local HOG ArtTools\hog_python core ENV
ECHO Before set_hog_py_init_env.cmd: HOG_PYTHON_VERSION=%HOG_PYTHON_VERSION%
CALL %~dp0../env/set_hog_py_init_env.cmd
ECHO After set_hog_py_init_env.cmd: HOG_PYTHON_VERSION=%HOG_PYTHON_VERSION%

set "HOG_PY_REQUIREMENTS=%HOG_PYTHONTOOLS_PATH%\shared\requirements"
set "HOG_PY_REQUIREMENTS_CORE=%HOG_PY_REQUIREMENTS%\requirements-%HOG_PYTHON_VERSION%-core.txt"

:: Check if requirements file exists
IF NOT EXIST "%HOG_PY_REQUIREMENTS_CORE%" (
    ECHO      [PYTHON] ERROR  ::  Requirements file not found: %HOG_PY_REQUIREMENTS_CORE%
    ECHO      [PYTHON] INFO   ::  Available requirement files:
    DIR /B "%HOG_PY_REQUIREMENTS%\requirements-*.txt"
    ECHO      [PYTHON] INFO   ::  Current Python version: %HOG_PYTHON_VERSION%
    PAUSE
    EXIT /B 1
)

IF EXIST "%HOG_PY_BASE_PYTHON_EXE%" (
    GOTO install_hog_py_base_core_packages
) ELSE (
   GOTO install_python_first
)

:install_python_first
ECHO      [PYTHON] INFO    ::  Could not find executable at %HOG_PY_BASE_PYTHON_EXE%
ECHO      [PYTHON] INFO    ::  Installing Python first...
CALL %~dp0get_python.bat
IF EXIST "%HOG_PY_BASE_PYTHON_EXE%" (
    GOTO install_hog_py_base_core_packages
) ELSE (
    ECHO      [PYTHON] ERROR  ::  Failed to install Python using get_python.bat
    ECHO      [PYTHON] WARNING::  Create the Virtual Environment (.venv)
    ECHO      [PYTHON] RUN    ::  scripts\get_python.bat manually
    PAUSE
    exit /B 1
)

:install_hog_py_base_core_packages
REM install the requirements\requirements-core.txt into base
echo Calling PIP to install "%HOG_PY_REQUIREMENTS_CORE%"
echo    Into: %HOG_PY_BASE_INSTALL%%
echo.
call %HOG_PY_BASE_PYTHON_EXE% -m pip install -r "%HOG_PY_REQUIREMENTS_CORE%" --disable-pip-version-check --no-warn-script-location
if ERRORLEVEL 1 (
    echo Failed installing requirements into `base` Python ...
    echo Requirements packages could not be installed: %HOG_PY_REQUIREMENTS_CORE%
    EXIT /b 1
)

IF EXIST "%HOG_PY_BASE_VENV_PIP%" (
    GOTO install_hog_py_base_venv_packages_core
) ELSE (
   GOTO venv_core_update_failure
)

:venv_core_update_failure
ECHO      [PYTHON] ERROR  ::  Could not find executable at %HOG_PY_BASE_VENV_PIP%
ECHO      [PYTHON] WARNING::  Create the Virtual Environment (.venv)
ECHO      [PYTHON] RUN    ::  scripts\get_python.bat
PAUSE
exit /B 1

:install_hog_py_base_venv_packages_core
REM install the requirements\requirements-core.txt into .venv
echo.
echo Calling PIP to install "%HOG_PY_REQUIREMENTS_CORE%"
echo    Into: %HOG_PY_BASE_VENV%%
echo.
call "%HOG_PY_BASE_VENV_PIP%" install -r "%HOG_PY_REQUIREMENTS_CORE%" --disable-pip-version-check --no-warn-script-location
if ERRORLEVEL 1 (
    echo Failed installing requirements into `.venv` Python ...
    echo Requirements packages could not be installed: %HOG_PY_REQUIREMENTS_CORE%
    EXIT /b 1
)

POPD
