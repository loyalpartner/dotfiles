set print object on
set print pretty on

# Print a C++ string.
define ps
  print $arg0.c_str()
end

define purl
  ps $arg0.spec()
end
document purl
Print GURL
Usage: pu url
end

# Print a C++ wstring or wchar_t*.
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


# Print stack trace with assertion scopes.
define mybt
python
import re
# frame_re = re.compile("^#(\d+)\s*(?:0x[a-f\d]+ in )?(.+) \(.+ at (.+)")
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

# vi: ft=gdb
