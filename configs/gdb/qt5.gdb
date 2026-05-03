# Qt5 Pretty Printers Integration

python
import sys
import gdb
from os.path import expandvars

try:
    gdb_dir = expandvars("$HOME/dotfiles/configs/gdb")
    if gdb_dir not in sys.path:
        sys.path.append(gdb_dir)
    import qt5printers
    qt5printers.register_printers(gdb.current_objfile())
    print("Qt5 printers registered")
except Exception as e:
    print(f"Failed to register Qt5 printers: {e}")
end
