@ECHO OFF
REM
REM Installs recommended VScode extenstions for a Bluepoint ArtTool

TITLE CP13 HOG ArtTools Python VScode Extensions
::COLOR 1e

:: Keep changes local
SETLOCAL EnableDelayedExpansion
:: Store current dir
PUSHD %~dp0

echo Installing HOG recommended VScode extensions for ArtTools Python ...

:: note: Use '--force' option to update to latest version or provide '@<version>'
:: to install a specific version, for example: 'ms-python.python@1.2.3'.
call code --install-extension ms-python.python
call code --install-extension ms-python.vscode-pylance
call code --install-extension ms-python.black-formatter
call code --install-extension charliermarsh.ruff
call code --install-extension ms-python.flake8
call code --install-extension magicstack.magicpython
call code --install-extension mjcrouch.perforce
call code --install-extension mohsen1.prettify-json
call code --install-extension donjayamanne.python-environment-manage
call code --install-extension nils-ballmann.python-coding-tools
call code --install-extension vscode-icons-team.vscode-icons

:END_OF_FILE
:: Return to starting directory
POPD
