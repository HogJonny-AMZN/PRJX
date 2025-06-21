@ECHO OFF
REM
REM HOG initialize HOG Python Env [ for python developers ]

:: Store current dir
PUSHD %~dp0

REM Skip initialization if already completed
IF "%HOG_PY_DEV_ENV%"=="1" GOTO :END_OF_FILE

:: required base to get anywhere
CALL %~dp0set_hog_py_init_env.cmd
:: ECHO HOG_ROOT = %HOG_ROOT%
:: ECHO HOG_ARTTOOLS_PATH = %HOG_ARTTOOLS_PATH%
:: ECHO HOG_PYTHONTOOLS_PATH = %HOG_PYTHONTOOLS_PATH%

REM Local overrides to the core env, these are best SET in set_hog_user_dev_env.cmd
:: Custom override environment variables [early setup] (optional)
IF EXIST %HOG_PYTHONTOOLS_PATH%\env\set_hog_user_dev_env.cmd call %HOG_PYTHONTOOLS_PATH%\env\set_hog_user_dev_env.cmd

REM these are related directly to the local developer env (python, IDEs, etc.)
:: below are the default values if they are not set in User override file above
IF "%HOG_GLOBAL_DEBUG%"=="" ( SET "HOG_GLOBAL_DEBUG=0" )
IF "%HOG_PY_EARLY_DEBUG%"=="" ( SET "HOG_PY_EARLY_DEBUG=0" )
IF "%HOG_PY_SHOW_PATHS%"=="" ( SET "HOG_PY_SHOW_PATHS=0" )
IF "%HOG_PY_DEBUG_VERBOSE%"=="" ( SET "HOG_PY_DEBUG_VERBOSE=0" )
IF "%HOG_PY_DEBUG_PAUSE%"=="" ( SET "HOG_PY_DEBUG_PAUSE=0" )
IF "%HOG_PY_DEBUGGER%"=="" ( SET "HOG_PY_DEBUGGER=debugpy" )
:: CRITICAL:50 | ERROR:40 | WARNING:30
:: INFO:20     | DEBUG:10 | NOTSET:0
IF "%HOG_PY_LOGLEVEL%"=="" ( SET "HOG_PY_LOGLEVEL=20" )
IF "%HOG_PY_USE_VENV%"=="" ( SET "HOG_PY_USE_VENV=0" )

IF "%HOG_PY_DEBUG_VERBOSE%"=="1" ( ECHO Initializing::  %HOG_PYTHONTOOLS_PATH%\env\set_hog_py_env.cmd)

REM we install a versioned python 'base', and a 'venv' for the same version.
:: 'base' is distributed, and it's used for basic maintenance, including for making downstream DCC virtual environments.
:: 'base is modified very little: it has a minor number of basic direct package installs
:: 'venv' has PySide2 directly installed, and is used for core IDE development (mimic a DCC python runtime)
:: all other packages are installed into a shared location like HOG_python\shared\Python-3.10.8\Lib\site-packages
:: the venv bootstraps them from there, DCC tools also bootstrapped shared packages from there.
:: we are not required to distribute the venv's but we will always submit and distribute the versions shared packages
::IF "%HOG_PY_BASE%"=="" ( SET "HOG_PY_BASE=%HOG_PYTHONTOOLS_PATH%\Base" )
::IF "%HOG_PY_BASE_INSTALL%"=="" ( SET "HOG_PY_BASE_INSTALL=%HOG_PY_BASE%\Python-%HOG_PYTHON_VERSION%" )
::SET "HOG_PY_BASE_PYTHON_EXE=%HOG_PY_BASE_INSTALL%\python.exe"
::SET "HOG_PY_BASE_PYTHON_PIP=%HOG_PY_BASE_INSTALL%\scripts\pip3.exe"

::SET "HOG_PY_BASE_VENV=%HOG_PYTHONTOOLS_PATH%\.venv\Python-%HOG_PYTHON_VERSION%"
::SET "HOG_PY_BASE_VENV_EXE=%HOG_PY_BASE_VENV%\scripts\python.exe"
::SET "HOG_PY_BASE_VENV_PIP=%HOG_PY_BASE_VENV%\scripts\pip.exe"

REM base should be submitted and always available
:: SET "PYTHONHOME=%HOG_PY_BASE_INSTALL%" this should rarely be used unless you know what you are doing
SET "PYTHON=%HOG_PY_BASE_PYTHON_EXE%"

IF EXIST "%HOG_PY_BASE_VENV_EXE%" (
    GOTO hog_py_venv_exists
) ELSE (
   GOTO hog_py_env_continue
)

:hog_py_venv_exists
REM if venv exists use it instead
:: PYTHONHOME should only be sef late in a launcher that needs it set,
:: setting it can cause systemic issues and python errors
:: SET "PYTHONHOME=%HOG_PY_BASE_VENV%"
IF "%HOG_PY_USE_VENV%"=="1" ( SET "PYTHON=%HOG_PY_BASE_VENV_EXE%" )
IF "%HOG_PY_DEBUG_VERBOSE%"=="1" ( ECHO      [calling] scripts\get_python_version.py )
FOR /F "tokens=* USEBACKQ" %%F IN ( `"%PYTHON%" %HOG_PYTHONTOOLS_PATH%\scripts\get_python_version.py` ) DO ( SET "HOG_PYTHON_VERSION=%%F" )
IF "%HOG_PY_DEBUG_VERBOSE%"=="1" ( ECHO      [HOGPY] Got HOG_PYTHON_VERSION = `%HOG_PYTHON_VERSION%` )

:HOG_py_env_continue
REM new /HOG_python package locations
SET "HOG_PY_SHARED_3P_SITE=%HOG_PY_SHARED_3P%\Python-%HOG_PYTHON_VERSION%\Lib\site-packages"
:: these paths are related the one above does not have PySide2, the one below does.
SET "HOG_PY_SHARED_3P_GUI_SITE=%HOG_PY_SHARED_3P%\Python-%HOG_PYTHON_VERSION%-gui\Lib\site-packages"

REM This maybe hacks PySide2 to work because for some reason it's not
REM not sure why, it is installed directly into the core venv
SET QT_PLUGIN_PATH=%HOG_PY_BASE_VENV%\Lib\site-packages\PySide2\plugins\platforms

IF "%HOG_PY_DEBUG_VERBOSE%"=="1" (
   GOTO hog_py_env_debug_start
) ELSE (
   GOTO END_OF_FILE
)

REM This Section ECHO's for HOG_python local, see what ENVAR's are SET to at this point in execution
:hog_py_env_debug_start
echo.
ECHO Continuing::  %HOG_PYTHONTOOLS_PATH%\env\set_hog_py_env.cmd
echo.
ECHO      [HOGPY] HOG_GLOBAL_DEBUG = %HOG_GLOBAL_DEBUG%
ECHO      [HOGPY] HOG_PY_EARLY_DEBUG = %HOG_PY_EARLY_DEBUG%
ECHO      [HOGPY] HOG_PY_DEBUGGER = %HOG_PY_DEBUGGER%
ECHO      [HOGPY] HOG_PY_DEBUG_VERBOSE = %HOG_PY_DEBUG_VERBOSE%
ECHO      [HOGPY] HOG_PY_DEBUG_PAUSE = %HOG_PY_DEBUG_PAUSE%
ECHO      [HOGPY] HOG_PY_LOGLEVEL = %HOG_PY_LOGLEVEL%
echo.
ECHO       DONE
echo.

:END_OF_FILE

:: Set flag so we don't initialize environment twice
SET "HOG_PY_DEV_ENV=1"

IF "%HOG_PY_DEBUG_PAUSE%"=="1" ( PAUSE )

:: Return to starting directory
POPD
