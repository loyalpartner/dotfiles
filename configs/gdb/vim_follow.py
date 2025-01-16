import gdb
import os

PANE_TITLE_VIM = "vim_pane_title"
PANE_TITLE_GDB = "gdb_pane_title"


def ppipe(cmd):
    lines = os.popen(cmd).readlines()
    return [line.strip() for line in lines]


class VimClient:

    def __init__(self):
        self.servername = "gdb-server"

    def list_panes(self):
        return ppipe('tmux list-panes -F "#{pane_title}"')

    def is_vim_server_running(self):
        panes = self.list_panes()
        return PANE_TITLE_VIM in panes

    def init_vim_server(self):
        os.system(f"tmux select-pane -T {PANE_TITLE_GDB}")
        os.system(f"tmux split-window vim")
        os.system(f"tmux select-pane -T {PANE_TITLE_VIM}")
        os.system(f"tmux select-pane -l")
        os.system(f"sleep 0.2")

    def keep_in_vim(self):
        panes = self.list_panes()
        target = panes.index(PANE_TITLE_VIM) + 1

        if target == 0:
            print("Vim pane not found.")
            return

        os.system(f"tmux select-pane -t {target}")

    def exit(self):
        panes = self.list_panes()
        target = panes.index(PANE_TITLE_VIM) + 1

        if target == 0:
            print("Vim pane not found.")
            return

        os.system(f"tmux kill-pane -t {target}")

    def goto(self, filename, line):
        panes = self.list_panes()
        target = panes.index(PANE_TITLE_VIM) + 1

        if target == 0:
            print("Vim pane not found.")
            return

        gdb.execute(
            f"!tmux send-keys -t {target} \":edit +{line} {filename}\" C-m")


class VimFollowCommand(gdb.Command):
    def __init__(self):
        super(VimFollowCommand, self).__init__("fl", gdb.COMMAND_USER)
        self.vim_client = VimClient()

    def file(self):
        if gdb.selected_frame() is None:
            return None

        filename = gdb.selected_frame().find_sal().symtab.fullname()
        if not is_valid_source_file(filename):
            return None

        return filename

    def line(self):
        if gdb.selected_frame() is None:
            return 0
        return gdb.selected_frame().find_sal().line

    def follow(self, stay_in_vim: bool):
        if not is_tmux():
            return

        filename = self.file()
        line = self.line()

        if filename is None:
            print("Invalid file or line number.")
            return

        if not self.vim_client.is_vim_server_running():
            self.vim_client.init_vim_server()

        self.vim_client.goto(filename, line)

        if stay_in_vim:
            self.vim_client.keep_in_vim()

    def invoke(self, argument, from_tty):
        self.follow(True)


def is_valid_source_file(filename):
    # 检查文件是否存在
    return os.path.isfile(filename)


def is_tmux():
    return os.getenv('TMUX')


cmd = VimFollowCommand()

gdb.events.stop.connect(lambda event: cmd.follow(False))
gdb.events.gdb_exiting.connect(lambda event: cmd.vim_client.exit())
