import subprocess
import json
from pathlib import Path

env_json_path = Path("D:/dev/CP13/Build/ArtTools/HOG_python/scripts/env.json")

env_dict: dict = {}
with open(f"{env_json_path.__str__()}") as jsonf:
    env_dict = json.load(jsonf)

maya_bin = Path("C:/Program Files/Autodesk/Maya2024/bin")

standalone_bat = Path("D:/dev/CP13/Build/ArtTools/maya/standaloneBatch.bat")

win_sys_path = Path("C:/WINDOWS/system32")

p4_path = Path("C:/Program Files/Perforce")

powershell_path = Path(win_sys_path, "WindowsPowerShell", "v1.0").resolve()

env_dict["PATH"] = (
    f"{win_sys_path};"
    f"{powershell_path};"
    f"{p4_path};"
    f"{maya_bin};"
)

command = [f"{standalone_bat}"]

subprocess.Popen(command, env=env_dict)
