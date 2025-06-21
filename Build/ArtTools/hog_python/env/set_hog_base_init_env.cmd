@ECHO OFF
REM
:: Initialize HOG ArtTools core environment [ for python developers ]

:: Store current dir
PUSHD %~dp0

:: Skip initialization if already completed
IF "%HOG_BASE_INIT_ENV%"=="1" GOTO :END_OF_FILE

IF "%HOG_PY_DEBUG_VERBOSE%"=="" ( SET "HOG_PY_DEBUG_VERBOSE=0" )

REM Everything relies on HOG_ROOT
:: Change to root dir
CD /d %~dp0..\..\..\..\
:: Write root directory to main HOG_ROOT env var
FOR /f "tokens=1" %%B in ('CHDIR') do set HOG_ROOT=%%B
:: Strip trailing backspace
IF "%HOG_ROOT:~-1%"=="\" SET HOG_ROOT=%HOG_ROOT:~0,-1%
CD /d %~dp0

:: Jump path variables for file paths
SET PROJECT=%HOG_ROOT%
SET HOG_DATA=%PROJECT%\Data
SET HOG_SOURCEDATA=%PROJECT%\SourceData
SET LOCALROOT=//%COMPUTERNAME%/

REM !This remapping may be used elsewhere!
SET "HOG_REPOSITORY=%HOG_ROOT%\data"

:: This is also required if the BPE core tools env is bypassed
SET "HOG_ARTTOOLS_PATH=%HOG_ROOT%\Build\ArtTools"
SET "HOG_PYTHONTOOLS_PATH=%HOG_ARTTOOLS_PATH%\hog_python"

REM ! Legacy ArtTools/python3, TODO: update, refactor, move hog-packages !
SET "HOG_PACKAGES=%HOG_ARTTOOLS_PATH%\python3\hog-packages"
SET "HOG_PY_PACKAGES=%HOG_ARTTOOLS_PATH%\python3\hog-packages"
SET "HOG_PYTHON_PACKAGES=%HOG_PYTHONTOOLS_PATH%\hog-packages"

SET "DEBUGPY_LOG_DIR=%HOG_ARTTOOLS_PATH%\art_tools_logs\debugpy"

IF "%HOG_PY_DEBUG_VERBOSE%"=="1" (
   GOTO hog_base_init_debug_start
) ELSE (
   GOTO END_OF_FILE
)

:hog_base_init_debug_start
echo.
ECHO Initializing::  %~dp0set_hog_base_init_env.cmd
echo.
ECHO      [BASE] LOCALROOT = %LOCALROOT%
echo.
ECHO      [BASE] HOG_ROOT = %HOG_ROOT%
ECHO      [BASE] HOG_DATA = %HOG_DATA%
ECHO      [BASE] HOG_SOURCEDATA = %HOG_SOURCEDATA%
echo.
ECHO      [BASE] HOG_ARTTOOLS_PATH = %HOG_ARTTOOLS_PATH%
ECHO      [BASE] HOG_PYTHONTOOLS_PATH = %HOG_PYTHONTOOLS_PATH%
echo.
ECHO      [BASE] HOG_PACKAGES = %HOG_PACKAGES%
ECHO      [BASE] HOG_PY_PACKAGES = %HOG_PY_PACKAGES%
ECHO      [BASE] HOG_PYTHON_PACKAGES = %HOG_PYTHON_PACKAGES%
echo.
ECHO       DONE
echo.

:END_OF_FILE
:: Set flag so we don't initialize environment twice
SET "HOG_BASE_INIT_ENV=1"

:: Return to starting directory
POPD
