# Qt5 Pretty Printers Integration

python
import os.path
import sys
from os.path import dirname, join

def setup_qt5_printers():
    try:
        # Add qt5printers to Python path
        qt5_path = join(dirname(__file__), 'qt5printers')
        if qt5_path not in sys.path:
            sys.path.append(qt5_path)
        
        import qt5printers
        qt5printers.register_printers(gdb.current_objfile())
        print("Qt5 printers registered successfully")
    except Exception as e:
        print(f"Failed to setup Qt5 printers: {e}")

setup_qt5_printers()
end