#!/usr/bin/env python3
import gdb
import os
import hashlib
from os.path import exists, expandvars, join

class BreakpointManager:
    def __init__(self):
        self.cache_dir = expandvars('$HOME/.cache/gdb/breakpoints')
        os.makedirs(self.cache_dir, exist_ok=True)
        self.file_hash = ""

    def calculate_hash(self, content: bytes) -> str:
        """Calculate SHA256 hash of content"""
        hash_calculator = hashlib.sha256()
        hash_calculator.update(content)
        return hash_calculator.hexdigest()

    def get_breakpoint_file(self):
        """Get the breakpoint file path for current program"""
        progspace = gdb.current_progspace()
        if not (progspace and progspace.filename):
            return None
        hash_val = self.calculate_hash(progspace.filename.encode("utf-8"))
        return join(self.cache_dir, hash_val)

    def is_modified(self, file: str) -> bool:
        """Check if breakpoint file has been modified"""
        if not exists(file):
            return False

        with open(file, "rb") as f:
            hash_value = self.calculate_hash(f.read())

        if self.file_hash == "" or self.file_hash != hash_value:
            self.file_hash = hash_value
            return True
        return False

    def save(self):
        """Save current breakpoints"""
        bp_file = self.get_breakpoint_file()
        if bp_file:
            gdb.execute(f"save breakpoints {bp_file}")
            print("Breakpoints saved")

    def load(self):
        """Load saved breakpoints"""
        if not exists(self.cache_dir):
            os.makedirs(self.cache_dir)

        bp_file = self.get_breakpoint_file()
        if bp_file and self.is_modified(bp_file):
            gdb.execute("delete")
            gdb.execute(f"source {bp_file}")
            print("Breakpoints loaded")

class BreakpointCommands(gdb.Command):
    """Breakpoint management commands"""
    
    def __init__(self):
        super().__init__("breakpoints", gdb.COMMAND_USER)
        self.manager = BreakpointManager()

    def invoke(self, arg, from_tty):
        args = gdb.string_to_argv(arg)
        if not args:
            print("Usage: breakpoints [save|load|clear]")
            return

        cmd = args[0]
        if cmd == "save":
            self.manager.save()
        elif cmd == "load":
            self.manager.load()
        elif cmd == "clear":
            gdb.execute("delete")
            print("All breakpoints cleared")
        else:
            print(f"Unknown command: {cmd}")

# Register command and set up hooks
cmd = BreakpointCommands()
manager = BreakpointManager()

# Auto-save on exit
gdb.events.exited.connect(lambda event: manager.save())

# Auto-save/load on run
def on_new_objfile(event):
    manager.save()  # Save breakpoints from previous session
    manager.load()  # Load breakpoints for new session

gdb.events.new_objfile.connect(on_new_objfile)