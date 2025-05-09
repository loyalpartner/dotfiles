# Qt5 Pretty Printers Integration

python
import os.path
import sys
import gdb
from os.path import dirname, join, expandvars

def setup_qt5_printers():
    try:
        # Add printers directory to Python path
        printers_dir = expandvars("${HOME}/dotfiles/configs/gdb/modules/printers")
        if printers_dir not in sys.path:
            sys.path.append(printers_dir)
        
        import qt5printers
        qt5printers.register_printers(gdb.current_objfile())
        print("Qt5 printers registered successfully")
    except Exception as e:
        print(f"Failed to setup Qt5 printers: {e}")

setup_qt5_printers()
end