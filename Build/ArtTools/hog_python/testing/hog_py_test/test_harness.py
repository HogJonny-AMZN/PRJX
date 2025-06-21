"""
Hogwarts: a harness for running automated tests for the hog_py package.
Module: hog_py_test/test_harness.py
"""

import os
import logging as _logging
import importlib
from typing import Union
from pathlib import Path

# -------------------------------------------------------------------------
# module global scope``
__MODULE_NAME = "hog_py_test.test_harness"
__updated__ = "2025-04-16 14:59:28"
__version__ = "0.1.CP13"
__author__ = ["jGalloway"]
_LOGGER = _logging.getLogger(__MODULE_NAME)

_MODULE_LIST_HAS_TESTS = []
_MODULE_LIST_HAS_NO_TESTS = []


# -------------------------------------------------------------------------
def execute_all_tests(root_file_path: Union[str, Path, os.PathLike] = Path(__file__)):
    """
    This function will find all test classes in the hog_py/lib/hog_p4 directory and run them.
    :param root_file_path: (str, Path) The root file path to start the search from.
    """
    # notes: This assumes the testing suite has all site package dependancies for the modules

    root_file_path = Path(root_file_path).resolve()

    for py_file in root_file_path.parent.rglob("*.py"):
        run_module_test(py_file)


# -------------------------------------------------------------------------
def run_module_test(python_module_path):
    """This function will run a test for a single module"""
    # notes: This assumes each module has a TestClass with a .run_all_tests method
    #        and assumes each module implements the per-module logging pattern.
    #        The top level test harness will configure the logging for the test run
    #        i.e the test harness will set up file logging for the test run

    python_module_path = Path(python_module_path).resolve()

    # cast to a python import string
    module_import = python_module_path.as_posix().replace("/", ".").replace(".py", "")
    _LOGGER.debug(f"Importing: {module_import}")
    try:
        module_import = importlib.import_module(module_import)
    except ImportError as e:
        _LOGGER.error(f"Error importing module: {module_import}")
        _LOGGER.exception(f"{e}")
        return

    if hasattr(module_import, "TestClass"):
        _MODULE_LIST_HAS_TESTS.append(python_module_path)
        TestClass = getattr(module_import, "TestClass")
        _LOGGER.info(f"HAS TestClass: {str(python_module_path)}")
        TestClass()
        if hasattr(TestClass, "run_all_tests"):
            TestClass().run_all_tests()
        else:
            _LOGGER.warning(f"MISSING .run_all_tests: {str(python_module_path)}")

    else:
        _MODULE_LIST_HAS_NO_TESTS.append(python_module_path)
        _LOGGER.warning(f"NO TestClass: {str(python_module_path)}")
