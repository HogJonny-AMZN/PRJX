"""
Hogwarts: hog_py testing package
Package: test_hog_py
"""

import os
import site
from pathlib import Path
import logging as _logging

# -------------------------------------------------------------------------
__PACKAGE_NAME = "hog_py_test"
__updated__ = "2025-04-14 15:20:57"
__author__ = ["jgalloway", "#techart-general"]

__LOGGER = _logging.getLogger(__PACKAGE_NAME)
__LOGGER.addHandler(_logging.NullHandler())

# self bootstrapping
HOG_ARTTOOLS_PATH = Path(__file__).parents[3]
# default fallback, next line will override
HOG_ARTTOOLS_PATH = Path(
    os.getenv("HOG_ARTTOOLS_PATH", HOG_ARTTOOLS_PATH)
).resolve()

HOG_PY_PACKAGES = Path(HOG_ARTTOOLS_PATH, "python3/hog-packages")  # default fallback
HOG_PY_PACKAGES = Path(os.getenv("HOG_PY_PACKAGES", HOG_PY_PACKAGES)).resolve()

# Add site access path if not already accessible
if str(HOG_PY_PACKAGES) not in site.getsitepackages():
    site.addsitedir(str(HOG_PY_PACKAGES))
