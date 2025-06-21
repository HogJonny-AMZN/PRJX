"""retrieve the path to the python.exe"""
# -------------------------------------------------------------------------
import sys
from pathlib import Path
import shutil

def delete_pycache_folders(root_path):
    for path in root_path.rglob('__pycache__'):
        if path.is_dir():
            shutil.rmtree(path)
            print(f"Deleted: {path.resolve()}")

if __name__ == "__main__":
    root_path = Path("D:/dev/CP13/Build/ArtTools")
    delete_pycache_folders(root_path)
    sys.exit()
