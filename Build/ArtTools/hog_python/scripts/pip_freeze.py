"""
Returns a list of frozen, versioned, python packages
"""
# -------------------------------------------------------------------------

try:
    from pip._internal.operations import freeze
except ImportError:
    from pip.operations import freeze

packages = freeze.freeze()

output = ''
for pckg in packages:
    output += f"{pckg}\n"

print(output)