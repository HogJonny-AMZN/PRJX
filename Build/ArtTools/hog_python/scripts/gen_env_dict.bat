@ECHO OFF
REM
REM generate a generic system env.json (dict)

:: Store current dir
PUSHD %~dp0

CALL "D:\dev\CP13\Build\ArtTools\HOG_python\base\Python-3.10.8\python.exe" "gen_env_dict.py" > env.json