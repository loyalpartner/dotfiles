import os

# const target pane name
target_pane_name = "target_pane_to_show_code"

def is_tmux():
    return os.getenv('TMUX')

def list_panes():
    return os.popen('tmux list-panes -F "#{pane_title}"').readlines()

def is_target_pane_exists():

    panes = list_panes()
    panes = [pane.strip() for pane in panes]

    return target_pane_name in panes

def create_target_pane():
    # os.system("tmux split-window -h -p 30 '%s'" % target_pane_name)
    os.system("tmux split-window")


def sync_code_to_vim():
    # import gdb

    if not is_tmux():
        return

    if not is_target_pane_exists():
        create_target_pane()


print(sync_code_to_vim())
