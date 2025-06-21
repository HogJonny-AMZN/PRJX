"""
Bluepoint: common globals and CONST, initialized once pull anywhere
Package: HOG_py_dev/globals.py
Design tenets:
- common CONST data, DRY (do not repeat yourself)
- modular encapsulation, shared data
- validate and/or update once, update everywhere, etc.
Reference: https://www.mygreatlearning.com/blog/global-variables-in-python/
"""

import logging as _logging

try:
    import HOG_py.lib.HOG_boot as HOG_boot
except ImportError as e:
    _logging.error(f"Import error: {e}")
    raise e

# -------------------------------------------------------------------------
# module global scope
_MODULE_NAME = "HOG_py_dev.globals"
__updated__ = "2025-02-13 20:22:42"
__version__ = "0.1.CP13"
__author__ = ["jGalloway"]
_LOGGER = _logging.getLogger(_MODULE_NAME)