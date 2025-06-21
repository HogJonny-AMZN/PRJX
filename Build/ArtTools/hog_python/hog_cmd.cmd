@echo off
REM Cmd prompt initialized with environment variables

TITLE CP13 HOG ArtTools Python: hog_cmd.cmd
::COLOR 1e

:: Don't use SETLOCAL to ensure environment variables propagate
REM SETLOCAL EnableDelayedExpansion

:: Store current dir
PUSHD %~dp0

:: Create command prompt with environment
ECHO Hogwarts ./hog_cmd.cmd

ECHO Before any setup: HOG_PYTHON_VERSION=%HOG_PYTHON_VERSION%

SET "HOG_PY_DEBUG_VERBOSE=1"
SET "HOG_PY_USE_VENV=1"

:: enable access to PySide2 (if you run into any conflicts let me know, we can disable by default)
SET "USE_LOCAL_PYSIDE_ACCESS=1"

:: Call set_version.cmd first to ensure correct Python version
ECHO Calling set_version.cmd...
CALL %~dp0env\set_version.cmd
ECHO After set_version.cmd: HOG_PYTHON_VERSION=%HOG_PYTHON_VERSION%

:: Calls the entire hog_python\env setup
ECHO Calling hog_python_env.cmd...
CALL %~dp0hog_python_env.cmd
ECHO After hog_python_env.cmd: HOG_PYTHON_VERSION=%HOG_PYTHON_VERSION%

IF "%HOG_PY_DEBUG_VERBOSE%"=="1" (
   GOTO debug_args
) ELSE (
   GOTO run_dmc
)

:debug_args
REM enable these lines to troubleshoot if directory changes are correct
:: ECHO	CWD = %HOG_PYTHONTOOLS_PATH%
:: ECHO	Input args = %*%

:run_dmc
:: Return to starting directory
POPD

IF "%HOG_PY_SHOW_PATHS%"=="1" (
   ECHO PYTHONPATH=%PYTHONPATH%
   echo.
)

cd /d %HOG_PYTHONTOOLS_PATH%

ECHO Before venv activation: HOG_PYTHON_VERSION=%HOG_PYTHON_VERSION%

:: Force the correct venv path based on HOG_PYTHON_VERSION
SET "HOG_PY_BASE_VENV=%HOG_PYTHONTOOLS_PATH%\.venv\Python-%HOG_PYTHON_VERSION%"
ECHO Forced HOG_PY_BASE_VENV=%HOG_PY_BASE_VENV%

:: Create directory if it doesn't exist
IF NOT EXIST "%HOG_PY_BASE_VENV%" (
    ECHO Creating directory for venv: %HOG_PY_BASE_VENV%
    MKDIR "%HOG_PY_BASE_VENV%"
    ECHO You will need to run scripts\setup_venv.bat to set up the virtual environment
)

IF "%HOG_PY_USE_VENV%"=="1" (
    IF EXIST "%HOG_PY_BASE_VENV%\Scripts\activate.bat" (
        ECHO Activating venv at %HOG_PY_BASE_VENV%\Scripts\activate.bat
        CALL %HOG_PY_BASE_VENV%\Scripts\activate.bat
        ECHO After venv activation: HOG_PYTHON_VERSION=%HOG_PYTHON_VERSION%
    ) ELSE (
        ECHO Virtual environment not found at %HOG_PY_BASE_VENV%\Scripts\activate.bat
        ECHO Run scripts\setup_venv.bat to create it
    )
)

CALL %windir%\system32\cmd.exe /k %*%
IF !ERRORLEVEL!==0 (
    GOTO END_OF_FILE
) ELSE (
   GOTO hog_cmd_error
)

:hog_cmd_error
exit /B %ERRORLEVEL%

:END_OF_FILE

ENDLOCAL
