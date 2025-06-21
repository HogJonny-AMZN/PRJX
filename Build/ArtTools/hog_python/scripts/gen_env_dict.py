"""get a generic base and filtered env dict"""

import sys
import os
import json

# -------------------------------------------------------------------------
def check_is_ascii(value):
    """checks that passed value is ascii str"""
    try:
        value.encode('ascii')
        return True
    except (AttributeError, UnicodeEncodeError):
        return False

# -------------------------------------------------------------------------
# store a copy, so we can inspect/compare later
orig_env = os.environ.copy()

# we are going to pass the system environ
gen_env = os.environ.copy()

# prunes non-string key:value envars
gen_env = {key: value for key, value in gen_env.items() if check_is_ascii(key) and check_is_ascii(value)}

# will prune QT_ envars, to be used with QT bases apps like Maya or Wing
gen_env = {key: value for key, value in gen_env.items() if not key.startswith("QT_")}

# passing PYTHONHOME will cause systemic boot failure for maya and maybe other DCC apps
gen_env = {key: value for key, value in gen_env.items() if not 'PYTHONHOME' in key}

print(json.dumps(gen_env, sort_keys=True, indent=4, separators=(",", ": ")))

sys.exit()