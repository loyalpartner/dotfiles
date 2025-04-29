#!/usr/bin/env python3
import os
import gdb
from datetime import datetime
from os.path import exists, expandvars, join

class GDBLogger:
    def __init__(self, level='info'):
        self.level = level
        self.cache_dir = expandvars('$HOME/.cache/gdb')
        self.log_file = join(self.cache_dir, 'gdb.log')
        os.makedirs(self.cache_dir, exist_ok=True)
        
    def log(self, level, message):
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        with open(self.log_file, 'a') as f:
            f.write(f"[{timestamp}] {level.upper()}: {message}\n")
            
    def info(self, message):
        self.log('info', message)
        if self.level == 'debug':
            print(f"Info: {message}")
        
    def error(self, message):
        self.log('error', message)
        print(f"Error: {message}")

    def debug(self, message):
        if self.level == 'debug':
            self.log('debug', message)
            print(f"Debug: {message}")

logger = GDBLogger()

def load_module(name, base_dir=None):
    """Load a GDB module by name"""
    if base_dir is None:
        base_dir = expandvars('$HOME/dotfiles/configs/gdb/modules')
    
    base_path = join(base_dir, name)
    init_file = join(base_path, 'init.gdb')
    
    try:
        if exists(init_file):
            gdb.execute(f'source {init_file}')
            logger.info(f"Loaded module: {name}")
            return True
    except Exception as e:
        logger.error(f"Failed to load module {name}: {e}")
        return False

def validate_config(module_dir):
    """Validate the configuration structure"""
    required_dirs = ['printers', 'break_history', 'editors']
    missing_dirs = []
    
    for dir in required_dirs:
        dir_path = join(module_dir, dir)
        if not exists(dir_path):
            missing_dirs.append(dir_path)
            
    if missing_dirs:
        logger.error("Missing required directories:")
        for dir in missing_dirs:
            logger.error(f"  - {dir}")
        return False
        
    return True