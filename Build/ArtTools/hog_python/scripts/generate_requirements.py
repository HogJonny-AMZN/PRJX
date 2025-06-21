"""
Generates a requirements.txt file from within Blender python runtime.
"""

from pathlib import Path
import platform

import bpy

# ----------------------------------------------------------
# globals
CWD = Path("D:/dev/CP13/Build/ArtTools/blender/dev_py/shared").resolve()

PYTHON_VERSION = platform.python_version()
print(f"Python version: {PYTHON_VERSION}")


# ----------------------------------------------------------
def get_site_packages_path():
    import site

    return site.getsitepackages()[0]


# ----------------------------------------------------------
def generate_requirements(cwd: Path = CWD):
    import pkg_resources

    print(f"Current working directory: {cwd}")
    requirements_path = Path(cwd, f"requirements-{PYTHON_VERSION}.txt").resolve()
    print(f"Requirements file: {requirements_path}")

    print("Generating requirements ...")

    # Get the list of installed packages
    # Ensure requirements.txt exists and is writable
    if not requirements_path.exists():
        try:
            requirements_path.touch()
        except PermissionError:
            raise PermissionError(f"Cannot write to {requirements_path}")

    installed_packages = pkg_resources.working_set
    site_packages_path = get_site_packages_path()
    site_packages = pkg_resources.find_distributions(site_packages_path)
    sorted_packages = sorted(
        ["{}=={}".format(i.key, i.version) for i in installed_packages]
        + ["{}=={}".format(i.key, i.version) for i in site_packages]
    )

    # Write to requirements.txt
    with open(requirements_path, "w") as f:
        for package in sorted_packages:
            print(package)
            f.write(package + "\n")  # Add newline character after each package

    print(f"Finished writing requirements to: {requirements_path}")


if __name__ == "__main__":
    generate_requirements()
