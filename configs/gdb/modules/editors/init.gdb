# Editor Integration Module
# Provides integration with various editors (vim, emacs, etc.)

python
import os
import gdb
from os.path import dirname, join, expandvars

# Add module directory to Python path
module_dir = expandvars("${HOME}/dotfiles/configs/gdb/modules/editors")
if module_dir not in sys.path:
    sys.path.append(module_dir)

# Import editor manager
try:
    import editor_manager
    print("Editor integration module loaded")
except Exception as e:
    print(f"Failed to load editor integration module: {e}")
end