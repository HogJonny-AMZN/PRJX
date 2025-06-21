"""
Bluepoint: a developer package of python utilities
package: HOG_python/bp-packages/HOG_py_dev/__init__.py
"""

import os
import site
from pathlib import Path
import logging as _logging

# -------------------------------------------------------------------------
# global scope
__PACKAGE_NAME = "HOG_py_dev"
__updated__ = "2025-02-11 14:48:46"
__version__ = "0.1.CP13"
__author__ = ["jgalloway"]
__LOGGER = _logging.getLogger(__PACKAGE_NAME)
__LOGGER.addHandler(_logging.NullHandler())

__ALL__ = []

HOG_PY_DEV_PACKAGES = Path(__file__).parents[1]
if str(HOG_PY_DEV_PACKAGES) not in site.getsitepackages():
    site.addsitedir(str(HOG_PY_DEV_PACKAGES))

# we need a known roots, fail hard if can not resolve
try:
    _HOG_ROOT = Path(__file__).parents[5].resolve()  # default fallback
    HOG_ROOT = Path(os.getenv("HOG_ROOT", _HOG_ROOT)).resolve()
    os.environ["HOG_ROOT"] = HOG_ROOT.as_posix()
except NotADirectoryError as e:
    __LOGGER.exception(e)
    raise e

_HOG_ARTTOOLS_PATH = Path(__file__).parents[3]  # default fallback
HOG_ARTTOOLS_PATH = Path(os.getenv("HOG_ARTTOOLS_PATH", str(_HOG_ARTTOOLS_PATH)))
try:
    HOG_ARTTOOLS_PATH = HOG_ARTTOOLS_PATH.resolve(strict=True)
    os.environ["HOG_ARTTOOLS_PATH"] = str(HOG_ARTTOOLS_PATH)
except NotADirectoryError as e:
    __LOGGER.exception(e)
    raise e

# ArtTools/HOG_python
try:
    _HOG_PYTHONTOOLS_PATH = Path(HOG_ARTTOOLS_PATH, "HOG_python")
    HOG_PYTHONTOOLS_PATH = _HOG_PYTHONTOOLS_PATH
except NotADirectoryError as e:
    __LOGGER.exception(e)
    raise e


# old arttools/python3 folder
try:
    _HOG_PY_PACKAGES = Path(HOG_ARTTOOLS_PATH, "python3", "bp-packages")
    HOG_PY_PACKAGES = _HOG_PY_PACKAGES.resolve()
except NotADirectoryError as e:
    __LOGGER.exception(e)
    raise e

if str(HOG_PY_PACKAGES) not in site.getsitepackages():
    site.addsitedir(str(HOG_PY_PACKAGES))


try:  # force an error, to ensure module is starting
    import HOG_py.globals as HOG_globals  # noqa: F401
except ImportError as e:
    __LOGGER.error(e)
    pass


# -------------------------------------------------------------------------
if __name__ == "__main__":
    """Run module directly for basic package testing."""

    _logging.basicConfig(
        level=_logging.DEBUG,
        datefmt=HOG_globals.DATE_FORMAT,
        format=HOG_globals.FRMT_LOG_LONG,
    )

    __LOGGER.setLevel(_logging.DEBUG)
    __LOGGER.debug(f"HOG_ROOT: {HOG_ROOT}")
    __LOGGER.debug(f"HOG_ARTTOOLS_PATH: {HOG_ARTTOOLS_PATH}")
    __LOGGER.debug(f"HOG_PYTHONTOOLS_PATH: {HOG_PYTHONTOOLS_PATH}")
    __LOGGER.debug(f"HOG_PY_PACKAGES: {HOG_PY_PACKAGES}")
    __LOGGER.debug(f"HOG_PY_DEV_PACKAGES: {HOG_PY_DEV_PACKAGES}")

# END of file
