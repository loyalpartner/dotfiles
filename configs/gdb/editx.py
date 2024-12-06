import gdb
import subprocess
import os

def is_valid_source_file(filename):
    # 检查文件是否存在
    return os.path.isfile(filename)

class EditXCommand(gdb.Command):
    def __init__(self):
        super(EditXCommand, self).__init__("ex", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        # 获取远程目标的可执行文件相对路径
        filename = gdb.selected_frame().find_sal().symtab.fullname()
        line = gdb.selected_frame().find_sal().line


        # 检查文件和行号是否有效
        if is_valid_source_file(filename) and line > 0:
            # 构建 Vim 命令
            gdb.execute("!tmux kill-pane -a")
            vim_command = f"tmux split-window -h 'vim +{line} {filename}'"

            # 执行 Vim 命令
            subprocess.call(vim_command, shell=True)
        else:
            print("Invalid file or line number.")

# 注册 EditXCommand
EditXCommand()

