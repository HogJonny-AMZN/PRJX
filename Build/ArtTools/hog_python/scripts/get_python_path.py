"""retrieve the path to the python.exe"""
# -------------------------------------------------------------------------
import sys
from pathlib import Path

py_exe = Path(sys.executable)
py_dir = py_exe.parents[0]
print(py_dir.resolve())

sys.exit()