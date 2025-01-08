source ~/dotfiles/configs/gdb/break_history.py

define hook-quit
python save()
end

define hook-kill
python save()
end

define hook-run
python save()
python load()
end
