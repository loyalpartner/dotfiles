#!/usr/bin/env python3
import gdb
import os
import json
from os.path import exists, expandvars, join

class EditorConfig:
    def __init__(self):
        self.editor = "vim"
        self.split_direction = "vertical"
        self.width = "50%"
        self.follow_source = True
        self.server_name = "vim_pane_title"
        self.pane_title = "gdb_pane_title"
        
    @classmethod
    def from_file(cls, config_file):
        config = cls()
        if exists(config_file):
            try:
                with open(config_file, 'r') as f:
                    data = json.load(f)
                config.editor = data.get('editor', config.editor)
                config.split_direction = data.get('split_direction', config.split_direction)
                config.width = data.get('width', config.width)
                config.follow_source = data.get('follow_source', config.follow_source)
            except Exception as e:
                print(f"Error loading editor config: {e}")
        return config

class EditorManager:
    def __init__(self):
        self.config = EditorConfig.from_file(expandvars('$HOME/.config/gdb/editor.json'))
        self.current_file = None
        self.current_line = None

    def is_valid_file(self, filename):
        """Check if file exists and is readable"""
        return filename and exists(filename)

    def is_tmux(self):
        """Check if running inside tmux"""
        return bool(os.getenv('TMUX'))

    def setup_tmux_pane(self):
        """Set up tmux pane for editor"""
        os.system(f"tmux select-pane -T {self.config.pane_title}")
        os.system(f"tmux split-window vim")
        os.system(f"tmux select-pane -T {self.config.server_name}")
        os.system(f"tmux select-pane -l")
        os.system(f"sleep 0.2")

    def goto_source(self, filename, line):
        """Navigate to source location in editor"""
        if not self.is_valid_file(filename):
            print(f"Invalid file: {filename}")
            return False

        if not self.is_tmux():
            print("Editor integration requires tmux")
            return False

        # List all panes
        panes = os.popen('tmux list-panes -F "#{pane_title}"').read().splitlines()
        
        # Find editor pane or create it
        if self.config.pane_title not in panes and self.config.server_name not in panes:
            self.setup_tmux_pane()
        
        try:
            target = panes.index(self.config.server_name) + 1
        except ValueError:
            print("Failed to find editor pane")
            return False

        # Send keys to editor
        if self.config.editor == "vim":
            os.system(f'tmux send-keys -t {target} ":edit +{line} {filename}" C-m')
        elif self.config.editor == "emacs":
            os.system(f'tmux send-keys -t {target} "C-x C-f" "{filename}" C-m')
            os.system(f'tmux send-keys -t {target} "M-g g" "{line}" C-m')
        
        self.current_file = filename
        self.current_line = line
        return True

    def follow_source(self):
        """Follow source code in editor"""
        if not self.config.follow_source:
            return

        try:
            frame = gdb.selected_frame()
            if not frame:
                return
            
            sal = frame.find_sal()
            if not sal or not sal.symtab:
                return

            filename = sal.symtab.fullname()
            line = sal.line

            # Only update if location changed
            if filename != self.current_file or line != self.current_line:
                self.goto_source(filename, line)
        except Exception as e:
            print(f"Error following source: {e}")

class EditorCommand(gdb.Command):
    """Command to control editor integration"""
    
    def __init__(self, manager):
        super().__init__("editor", gdb.COMMAND_USER)
        self.manager = manager

    def invoke(self, arg, from_tty):
        args = gdb.string_to_argv(arg)
        if not args:
            print("Usage: editor [follow|goto|config]")
            return

        cmd = args[0]
        if cmd == "follow":
            self.manager.config.follow_source = not self.manager.config.follow_source
            print(f"Source following {'enabled' if self.manager.config.follow_source else 'disabled'}")
        elif cmd == "goto":
            frame = gdb.selected_frame()
            if frame:
                sal = frame.find_sal()
                if sal:
                    self.manager.goto_source(sal.symtab.fullname(), sal.line)
        elif cmd == "config":
            print(f"Editor: {self.manager.config.editor}")
            print(f"Split direction: {self.manager.config.split_direction}")
            print(f"Width: {self.manager.config.width}")
            print(f"Follow source: {self.manager.config.follow_source}")
        else:
            print(f"Unknown command: {cmd}")

# Initialize manager and command
editor_manager = EditorManager()
EditorCommand(editor_manager)

# Set up source following
if editor_manager.config.follow_source:
    gdb.events.stop.connect(lambda event: editor_manager.follow_source())
