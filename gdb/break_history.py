#!/usr/bin/env python

from os.path import exists, expandvars, join
import gdb
import os
import hashlib

cache_dir = expandvars('$HOME/.cache/gdb')

if not exists(cache_dir):
    os.mkdir(cache_dir)

file_hash = ""


def calculate_hash(content: bytes):
    hash_calculator = hashlib.sha256()
    hash_calculator.update(content)
    return hash_calculator.hexdigest()


def modified(file: str):
    global file_hash

    if not exists(file):
        return False

    hash_value = ""
    with open(file, "rb") as f:
        hash_value = calculate_hash(f.read())

    if file_hash == "" or file_hash != hash_value:
        file_hash = hash_value
        return True

    return False


def save():
    progspace = gdb.current_progspace()
    filename = progspace and progspace.filename
    if filename:
        hash = calculate_hash(filename.encode("utf-8"))
        breakpoints_file = join(cache_dir, hash)

        gdb.execute("save breakpoints %s" % breakpoints_file)
        print("save breakpoints")


def load():
    if not exists(cache_dir):
        os.mkdir(cache_dir)

    progspace = gdb.current_progspace()
    filename = progspace and progspace.filename
    if filename:
        hash = calculate_hash(filename.encode("utf-8"))
        breakpoints_file = join(cache_dir, hash)

        if not modified(breakpoints_file):
            return

        gdb.execute("delete")
        gdb.execute("source %s" % breakpoints_file)
        print("load breakpoints")


# gdb.events.exited.connect(lambda event: save())

# vim: set sw=2 ts=2 sts=2 et tw=78;
