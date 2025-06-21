@ECHO OFF
REM
REM Initializes the environment for ArtTools\hog_python
:: This is used to Launch VScode and other apps within this environment context

:: Store current dir
PUSHD %~dp0
ECHO CWD Dir: %~dp0

:: enable for env troubleshooting
IF "%HOG_PY_DEBUG_VERBOSE%"=="" ( SET "HOG_PY_DEBUG_VERBOSE=1" )
:: enable adding local PySide2 "-gui" site packages
IF "%USE_LOCAL_PYSIDE_ACCESS%"=="" ( SET "USE_LOCAL_PYSIDE_ACCESS=0" )

REM Skip initialization if already completed
IF "%HOG_PYTHON_ENV_IS_SET%"=="1" GOTO :END_OF_FILE

IF "%HOG_PY_DEBUG_VERBOSE%"=="1" (
   GOTO hog_python_first_debug_start
) ELSE (
   GOTO first_continue
)

:hog_python_first_debug_start
ECHO Initializing: %~dp0hog_python_env.cmd
echo.

CALL %~dp0env\set_version.cmd

:first_continue
CALL %~dp0env\set_hog_py_init_env.cmd

:: Custom override environment variables [early setup]
IF EXIST %~dp0env\set_hog_user_dev_env.cmd call %~dp0env\set_hog_user_dev_env.cmd

CALL %HOG_PYTHONTOOLS_PATH%\env\set_hog_py_env.cmd

:POST_SET_HOG_CORE_ENV
SET "HOG_PATH_CMD=%HOG_PYTHONTOOLS_PATH%\env\set_hog_base_python_PATH.cmd"
IF "%HOG_PY_USE_VENV%"=="1" ( SET "HOG_PATH_CMD=%HOG_PYTHONTOOLS_PATH%\env\set_hog_venv_python_PATH.cmd" )
CALL %HOG_PATH_CMD%

CALL %HOG_PYTHONTOOLS_PATH%\env\set_hog_python_PYTHONPATH.cmd

IF "%HOG_PY_DEBUG_VERBOSE%"=="1" (
   GOTO hog_python_env_debug_start
) ELSE (
   GOTO END_OF_FILE
)

:hog_python_env_debug_start
ECHO      [PYENV] Check potential ENVAR overrides that may have been set in:
ECHO      [PYENV]   "%HOG_PYTHONTOOLS_PATH%\env\set_hog_user_dev_env.cmd"
echo.
ECHO      [PYENV] HOG_ROOT = %HOG_ROOT%
ECHO      [PYENV] HOG_ARTTOOLS_PATH = %HOG_ARTTOOLS_PATH%
ECHO      [PYENV] HOG_PYTHONTOOLS_PATH = %HOG_PYTHONTOOLS_PATH%
echo.
ECHO      [PYENV] HOG_PY_LOGLEVEL = %HOG_PY_LOGLEVEL%
ECHO      [PYENV] HOG_GLOBAL_DEBUG = %HOG_GLOBAL_DEBUG%
ECHO      [PYENV] HOG_PY_EARLY_DEBUG = %HOG_PY_EARLY_DEBUG%
ECHO      [PYENV] HOG_PY_DEBUG_VERBOSE = %HOG_PY_DEBUG_VERBOSE%
ECHO      [PYENV] HOG_PY_DEBUG_PAUSE = %HOG_PY_DEBUG_PAUSE%
echo.
ECHO      [PYENV] HOG_PY_USE_VENV = "%HOG_PY_USE_VENV%"
ECHO      [PYENV] HOG_PYTHON_VERSION = Python-%HOG_PYTHON_VERSION%
ECHO      [PYENV] HOG_PY_BASE_INSTALL = %HOG_PY_BASE_INSTALL%
ECHO      [PYENV] HOG_PY_BASE_PYTHON_EXE = %HOG_PY_BASE_PYTHON_EXE%
ECHO      [PYENV] HOG_PY_SHARED_3P_SITE = %HOG_PY_SHARED_3P_SITE%
ECHO      [PYENV] HOG_PACKAGES = %HOG_PACKAGES%
ECHO      [PYENV] HOG_PYTHON_PACKAGES = %HOG_PYTHON_PACKAGES%
ECHO      [PYENV] HOG_PY_BASE_VENV = %HOG_PY_BASE_VENV%
ECHO      [PYENV] HOG_PY_BASE_VENV_EXE = %HOG_PY_BASE_VENV_EXE%
echo.
ECHO      [PYENV] PYTHON = "%PYTHON%"
echo.

IF EXIST "%PYTHON%" (
   GOTO END_OF_FILE
) ELSE (
   GOTO hog_python_venv_not_installed
)

:hog_python_venv_not_installed
ECHO      [PYENV] ERROR::  Could not find python executable at %PYTHON%

IF "%HOG_PY_USE_VENV%"=="1" (
   ECHO      [PYENV] WARN :: scripts\setup_venv.bat
) ELSE (
   ECHO      [PYENV] WARN ::  Run: get_python.bat
)
echo.

:END_OF_FILE

:: Set flag so we don't initialize environment twice
SET "HOG_PYTHON_ENV_IS_SET=1"

:: Return to starting directory
POPD
