# Pretty Printers Module
# Configures various pretty printers for better data visualization

# Load basic pretty printing settings
set print pretty on
set print object on
set print array on
set print array-indexes on
set print static-members on
set print vtbl on
set print demangle on
set print asm-demangle on

# Print a C++ string
define ps
    print $arg0.c_str()
end
document ps
Print a C++ string using c_str()
Usage: ps string_variable
end

# Print a C++ wstring
define pws
    printf "\""
    set $c = (wchar_t*)$arg0
    while ( *$c )
        if ( *$c > 0x7f )
            printf "[%x]", *$c
        else
            printf "%c", *$c
        end
        set $c++
    end
    printf "\"\n"
end
document pws
Print a C++ wstring or wchar_t*
Usage: pws wstring_variable
end

# Print stack trace with assertion scopes
define mybt
python
import re
frame_re = re.compile("^#(\d+)\s*(?:0x[a-f\d]+ in )?(\w*(::\w+|::\([\w\s]+\))*)\(")
btl = gdb.execute("backtrace full", to_string = True).splitlines()
for l in btl:
    match = frame_re.match(l)
    if match:
        print("%-60s" % (match.group(2)))
end
end
document mybt
Print stack trace with assertion scopes
Usage: mybt
end

# Load Qt5 printers if available
source ${HOME}/dotfiles/configs/gdb/modules/printers/qt5.gdb