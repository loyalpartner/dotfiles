# Breakpoint History Module
# Provides persistence for breakpoints across GDB sessions

python
import os
import gdb
from os.path import expandvars, dirname, join

# Add module directory to Python path
module_dir = expandvars("${HOME}/dotfiles/configs/gdb/modules/break_history")
if module_dir not in sys.path:
    sys.path.append(module_dir)

# Import and initialize breakpoint manager
try:
    import break_history
    print("Breakpoint history module loaded")
except Exception as e:
    print(f"Failed to load breakpoint history module: {e}")
end