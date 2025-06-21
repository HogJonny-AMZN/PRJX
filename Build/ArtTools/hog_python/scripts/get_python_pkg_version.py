"""
Returns a string in the form python version: `major.minor`
e.g. >3.10
"""

# -------------------------------------------------------------------------
import sys
print(f"{sys.version_info.major}.{sys.version_info.minor}")

sys.exit()