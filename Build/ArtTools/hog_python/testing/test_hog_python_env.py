"""
Hogwarts: /hog_python, developer environment testing
Module: test_hog_python_env.py
"""
import sys
import os
import platform
from pathlib import Path
import logging as _logging
import timeit
import hog_py.globals as hog_globals

# -------------------------------------------------------------------------
# module global scope
__MODULE_START = timeit.default_timer()  # start tracking
_MODULE_NAME = "hog_python.testing.test_hog_python_env"
_LOGGER = _logging.getLogger(_MODULE_NAME)

__version__ = __version__ = "0.3.CP13"
__updated__ = "2025-06-19 00:22:07"
__author__ = ["jGalloway", "#techart-general"]

# creates and adds StreamHandler with formatting to root logger
_logging.basicConfig(level=_logging.DEBUG, datefmt=hog_globals.DATE_FORMAT, format=hog_globals.FRMT_LOG_LONG)

_logger = _logging.getLogger(_MODULE_NAME)

_logger.info(f"Initializing: {_MODULE_NAME}.py")

# To Do: set up file _logging for testing.
# To Do: write a common shared test harness with init/configuration


# -------------------------------------------------------------------------
def check_envar(envar_key: str = "", logger: _logging.Logger = _logger):
    """Checks that an ENVAR exists / is set"""
    # To Do: move this to BPcore.python.utils
    # logger.info(f'Executing: {_MODULE_NAME}.check_envar({envar_key})')

    try:
        envar_value = os.environ[envar_key]
        logger.info(f"SUCCESS: {envar_key} = {envar_value}")
        return 0, envar_value
    except Exception as EnvironmentError:
        logger.exception(EnvironmentError)
        # traceback.print_exc()
        return 1, EnvironmentError


# -------------------------------------------------------------------------
def get_python_path(logger: _logging.Logger = _logger):
    """! @brief
    Will print the ENVAR HOG_MAYA_PYTHONHOME, if set. Except if not.
    Will return path to python.exe, also to compare
    """
    # To Do: move this to HOGcore.python.utils
    # logger.debug(f'Executing: {_MODULE_NAME}.get_python_path()')

    try:
        envar_value = Path(check_envar("HOG_MAYA_PYTHONHOME", None)[1]).resolve()
        envar_value.exists()
        logger.info(f"HOG_MAYA_PYTHONHOME is : {envar_value}")
        python_exe = Path(sys.executable).resolve()
        check_py_exe = Path(envar_value, "python.exe").resolve()
        python_exe == check_py_exe
        logger.info(f"Validated:: python.exe : {python_exe}")

    except Exception as e:
        return e

    return python_exe, 0


# -------------------------------------------------------------------------
def get_python_version(logger: _logging.Logger = _logger):
    """! @brief
    Returns a string in the form major.minor.patchlevel.
    e.g. 3.9.9
    """
    # To Do: move this to BPcore.python.utils
    # logger.debug(f'Executing: {_MODULE_NAME}.get_python_version()')

    return logger.debug(f"platform.python_version : {platform.python_version()}")


# -------------------------------------------------------------------------
def import_tests(logger: _logging.Logger = _logger):
    """! @brief
    Returns a string in the form major.minor.patchlevel.
    e.g. 3.9.9
    """
    logger.debug(f"Executing: {_MODULE_NAME}.import_tests()")    try:
        import HOGcore
    except Exception as ImportError:
        logger.exception(ImportError)
        # traceback.print_exc()
        return 1, ImportError

    try:
        HOGcore.maya
    except Exception as ImportError:
        return 1, ImportError

    # To do: for now this will fail (no PySide2)
    # need to figure out if we can install Qt/PySide2 into venv without conflict
    try:
        import HOG_mPy
    except Exception as ImportError:
        logger.exception(ImportError)
        # traceback.print_exc()
        return 1, ImportError

    logger.info(f"Executing: {_MODULE_NAME}.import_tests():: COMPLETE")
    return 0


# -------------------------------------------------------------------------
def run_test(logger: _logging.Logger = _logger):
    """this method will execute the test(s)"""

    logger.info(f"Executing: {_MODULE_NAME}.run_test()")    try:
        check_envar("HOG_ROOT", logger)
        check_envar("HOG_ARTTOOLS_PATH", logger)
        check_envar("HOG_MAYA_PYTHONHOME", logger)
        check_envar("MAYA_NATIVE_PYTHON_EXE", logger)
        get_python_path(logger)
        get_python_version(logger)
        import_tests(logger)

    except Exception as e:
        return e

    return 0


# -------------------------------------------------------------------------
if __name__ == "__main__":
    """! @brief
    This block executes a test of the environment for HOG Substance Designer.    Usage::
        d:/> cd D:/dev/CP13/Build/ArtTools/substance/SubstanceDesigner
        d:/> python.cmd scripts\\tests\\test_hog_subd_env.py
    """

    _test_logger = _logging.getLogger(f"{_MODULE_NAME}.__main__")

    _test_logger.info(f"Last update of this file was on {__updated__}")

    _test_logger.info(f"Running {_MODULE_NAME} as {__name__}")

    _test_logger.info(f"Attempting:: {_MODULE_NAME}.run_test()")
    try:
        _exit_value = run_test(logger=_test_logger)
    except Exception as e:
        _logger.warning(f"FAILURE: {_MODULE_NAME}.run_test()")
        _logger.warning(f"{_MODULE_NAME} Exception report")
        _logger.exception(f"{e}")
        raise e

    _test_logger.info(
        f"COMPLETE: {_MODULE_NAME}.{__name__}: _exit_value = {_exit_value}"
    )
    _MODULE_END = timeit.default_timer() - __MODULE_START
    _test_logger.info(f"TIMER: {_MODULE_NAME}.run_test(): {_MODULE_END} sec")

    sys.exit(_exit_value)
