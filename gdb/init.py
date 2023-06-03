from os.path import exists, expandvars

def source(config):
  config=expandvars(config)
  if exists(config):
    execute('source %s' % config)

def execute(cmd, debug=True):
  if debug:
    print(cmd)
  gdb.execute(cmd)

def init_gdb_configs():
  gdb_configs=[
    '$HOME/modous/R113/chromium/src/tools/gdb/gdbinit'
  ]
  [source(config) for config in gdb_configs]


def init_jsdbg():
  # https://github.com/MicrosoftEdge/JsDbg
  jsdbg_dir=expandvars('${XDG_CONFIG_HOME:-$HOME/.config}/jsdbg-gdb')

  if exists(jsdbg_dir):
    sys.path.insert(0, jsdbg_dir)
    import JsDbg

def main():
  # init_gdb_configs()
  init_jsdbg()

main()
