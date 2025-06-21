# HOG_python (vscode)

This is a BPE (CP13) shared development framework for Python Developers using Visual Studio Code (VScode).

## TL/DR:

The current folder (of this readme), holds the workspace file:

```
CP13/ArtTools/HOG_python/HOG_python.code-workspace
```

You can currently open this workspace using this workflow:

1. To start VScode with this workspace, run: `start_vsc.bat`
2. If VScode is already running, you can also use this alternative:
   1. `VScode > File > Open Workspace from File ...`
   2. Browse to: `CP13/Build/ArtTools/HOG_python/`
   3. Pick to open: `HOG_python.code-workspace`

## Why?

1. Importantly: We focus on the 'driver experience' without knowing how to build the engine and hotrod. Newbies or less technical people can onboard quickly into our codebase, where a workspace and nicely featured IDE works out of box with low effort (or understanding.)

2. We need a base vanilla python development area agnostic to DCC's

3. This modernizes and replaces the old `ArtTools/python/` (python27) and `ArtTools/python3/` (python39) folders, and deprecates them.

4. This `HOG_python/` folder can maintain and manage multiple versioned Python Virtual Environments (`/.venv/**`).

5. These venv's are used for maintaining _versioned_ package distribution in a more modernized way that increases compatibility / decreases collisions and packages incompatible with various versions of Python. Example see: `HOG_python/shared/Python-3.10.8`(one versioned and specific to per-venv) These will replace and deprecate the old `/python3/site-packages39` and `/python3/site-packages39`; as well instead of trying to share packages across all DCC tools, instead each DCC workspace will be capable of building it's own customized sit package location for bootstrapping, catering specifically to the needs of that DCC tool; e.g. `ArtTools/maya/shared/Python-3.XX.xx`

6. Reduce potential error of deviation: IDE Workspaces that allow us to develop in an IDE that is a mimic of how the tools operate live with an End User (run in IDE under the same conditions as running within a tool); i.e. the same BPE tool framework environment is initialized, as well as our local TechArt extensions, shared Python packages, etc.

7. Familiarity across DCC code workspaces; they are all constructed similarly and can be operated similarly.

8. The intent is that this is better development because you are as close as possible to the runtime state, accessing the same locations and packages, etc.

9. Environment that is more data-driven and configurable; i.e. enable ENVARs for access to developer features like embedded 'debug logic and validation', debugging configuration, remote debugging, etc.

10. Developer creature comforts: improved api inspection and auto-complete aka intellisense (pylance analysis), formatting (Flake8, Black and Ruff), and other useful VScode extensions that make our lives easier and help us create a more consistent code base.

## HOG_python.code-workspace

Here is outlined a general sense of what you will find in the workspace

### Files

| File                        | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `HOG_cmd.cmd`               | Double-click to launch a 'Command Console', which initializes the workspace environment (utilizes the files in `/env/**`); i.e. you have the same environment and access that Python or a tool would have. Importantly, the VScode workspace uses this to initialize the 'Embedded Terminal', so if you are running a _.py_ script in the IDE terminal it's as close as possible to how it's going to run in the wild.  (This calls `hog_python_envcmd` under the hood to initialize the environment.)  When VScode changes workspaces, it also automatically initializes this (effectively refreshing the terminal env to the local workspace.) |
| `HOG_python.code-workspace` | This is the VScode workspace definition file; it has all kinds of settings that configure the IDE to work best with the local framework and features (as well as developer creature comforts.)                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `hog_python_envcmd`         | Instead of needing to muck with creating a launcher that handles all of the files in `/env/**`, in a launcher, commandlet, you can just call this one file to initialize it all (ENVAR's, paths, etc.)  Examples: HOG*cmd.cmd calls this directly, so does python.cmd and start_vsc.bat also calls this.  (i.e. easy access shared env, this is considered modular and DRY '\_do not repeat yourself*' configuration.)                                                                                                                                                                                                                           |
| `cmd.exe`                   | You can treat this just like a normal `cmd.exe`.  This is a soft symlink, it wraps`HOG_cmd.cmd` to make it appear is if it's a generic `cmd.exe` file; why? some IDE settings/processes are expecting to access a `cmd.exe` (and even pass it args), so this ensures that those processes will be in the same environment context (with our environment active.)                                                                                                                                                                                                                                                                                 |
| `python.cmd`                | Double-clicking this will start a interactive Python terminal; like `HOG_cmd.cmd` this initializes the environment; i.e. it has all the same ENVARs and settings, `PATH` and `PYTHONPATH` access, etc.  You can for instance use this as a standalone external terminal in testing module imports, running module methods, etc.  it can be called from the commandline with args just like `python.exe` to run/start modules, as such can be used to start things, build automated testing, etc.  Note: in addition to cli args, you can drag and drop a .py script onto this to run it.                                                         |
| `python.exe`                | Like the `cmd.exe`, this is a soft symlink to wrap `python.cmd` and make it appear as a `python.exe`, i.e. it looks like Python and Quacks like Python.  (Under the hood it's our environment and the Python virtual environment bootstrapped with packages, etc. )  Anything that you might generally send to a `python.exe` you can just send to this, so we can have familiar standard patterns across workspaces.  (Users don't have to know how it's built or that it's anything special.)  Note: not sure yet if an internal setting/process in the workspace can use this directly as an interpreter.)                                    |
| `README.md`                 | Markdown style local documentation(the document you are currently reading)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `start_vsc.bat`             | Double-click this to start Visual Studio Code (VScode) in the local workspace.  Note: you can also _drag-and-drop_ a `*.code-workspace` file onto this (for instance a temp sandbox workspace, custom user workspace, or a tool specific workspace, etc.), you can do the same from a command console `start_vsc.bat ./my_custom.code-workspace`                                                                                                                                                                                                                                                                                                 |

### Folders

Use the VScode Explorer (file tree browser, an outliner on the left of the editor)

You should see these folders:

| Folder     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/.cspell` | workspace shared custom dictionary for IDE                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `/.venv`   | Holds at least _one_ base python `virtual environment` to use in development of the DCC tool workspaces; it uses a common ENVAR environment, has access to distributed python packages, as well as the internal `bp-packages`   This makes it a suitable non-DCC specific Python runtime suitable for creating cli utilities, standalone tools, batch automation, automated testing, etc.  You can make many new versioned and customized venvs here, example: `/.venv/MyTool-3.11.2/*` |
| `/.vscode` | VScode workspace settings (also folder specific settings if folder is used in a nested multi-workspace.)                                                                                                                                                                                                                                                                                                                                                                                |
| `/base`    | A generic vanilla versioned Python install, e.g. `Python-3.10.8`, this version is currently tied to the studio production Maya version that is supported (2024.2)  This is in it's natural state with few modifications (pip is updated to latest, 2 core packages used in framework are installed); we can always rely on this being here, it can be used during the maintenance of the framework, creating new versioned venv's, package management, etc.                             |
| `/env`     | A set of files that initialize and stand up the environment context (ENVARs); can enable the BPE tools environment, manage `PATH` `PYTHONPATH` access, and other features.  These are what allow the IDE to run as if it was launched from GameConnection.  Note: this folder will have it's own README.md                                                                                                                                                                              |
| `/scripts` | A set of utility Python scripts (_.py_), and commandlets (_.cmd_) used in the the framework and environment (to make it more procedural and data-driven, rather then monolithic and hard coded.)  Note: this folder will have it's own README.md                                                                                                                                                                                                                                        |
| `/shared`  | The location where versioned Python packages are maintained and distributed; i.e. we have a set of non-vanilla 3rd party packages we want to commonly use and provide access to be bootstrapped.                                                                                                                                                                                                                                                                                        |
| `/testing` | Basic module testing, test data, automated testing (or unit testing if we get to that.)  Note: as this folder grows with tests, it also will have it's own README.md                                                                                                                                                                                                                                                                                                                    |

## What to Know:

1. Multi-folder nested workspaces; VScode allows you to have a top-level workspace that includes multiple child workspaces. This would allow you to have access the all the DCC frameworks at once (this work is not complete):

   1. `ArtTools/ArtTools.code-workspace`

   2. `ArtTools/.vscode/settings.json`

   3. `ArtTools/start_vsc.bat`

2. When each child workspace has a file like `ArtTools/maya/.vscode/.settings.json` the folder can specify what it's local Python interpreter is. So a python script in the maya workspace will will fun that workspace's default interpreter (some version of mayapy.exe)

3. All of this is adaptable to other User preferred IDE's such as Wing, PyCharm, etc. (this isn't done yet though.)
