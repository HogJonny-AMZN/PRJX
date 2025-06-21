@ECHO OFF
REM
REM This will install/update our shared distributed python packages

:: Store current dir
PUSHD %~dp0

IF "%HOG_PYTHON_VERSION%"=="" ( SET "HOG_PYTHON_VERSION=3.11.4" )

:: Local HOG ArtTools\hog_python core ENV
CALL %~dp0..\env\set_hog_py_init_env.cmd
IF EXIST %HOG_PYTHONTOOLS_PATH%\env\set_hog_user_dev_env.cmd call %HOG_PYTHONTOOLS_PATH%\env\set_hog_user_dev_env.cmd
CALL %HOG_PYTHONTOOLS_PATH%\env\set_hog_py_env.cmd

set "HOG_PY_REQUIREMENTS=%HOG_PYTHONTOOLS_PATH%\shared"
set "HOG_PY_REQUIREMENTS_3P_GUI=%HOG_PY_REQUIREMENTS%\requirements-%HOG_PYTHON_VERSION%-gui.txt"

IF EXIST "%HOG_PY_BASE_VENV_EXE%" (
    GOTO install_hog_py_shared_packages_gui
) ELSE (
   GOTO gui_packages_failure
)

:gui_packages_failure
ECHO      [PYTHON] ERROR  ::  Could not find python executable at %HOG_PY_BASE_VENV_EXE%
ECHO      [PYTHON] WARNING::  Create the Virtual Environment (.venv)
ECHO      [PYTHON] RUN    ::  scripts\setup_venv.bat
PAUSE
exit /B 1

:install_hog_py_shared_packages_gui
REM install the requirements\requirements-gui.txt into bootstrap 3P site-packages
echo Calling PIP to install "%HOG_PY_REQUIREMENTS_3P_GUI%" into bootstrap `shared` 3P site-packages ...
echo    Into: %HOG_PY_SHARED_3P_GUI_SITE%
echo.
call "%HOG_PY_BASE_VENV_PIP%" install -r "%HOG_PY_REQUIREMENTS_3P_GUI%" --target="%HOG_PY_SHARED_3P_GUI_SITE%" --disable-pip-version-check --no-warn-script-location
if ERRORLEVEL 1 (
    echo Failed installing requirements into 3P Python bootstrap `shared` site-packages ...
    echo Requirements packages could not be installed: %HOG_PY_REQUIREMENTS_3P_GUI%
    echo Failed to install the packages listed in: %HOG_PY_SHARED_3P_GUI_SITE%.  Check the log above!
    EXIT /b 1
)

POPD
