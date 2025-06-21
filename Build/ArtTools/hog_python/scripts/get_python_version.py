"""
Returns a string in the form major.minor.patchlevel.
e.g. >3.10.8
"""
# -------------------------------------------------------------------------
import sys
import platform

print(platform.python_version())

sys.exit()