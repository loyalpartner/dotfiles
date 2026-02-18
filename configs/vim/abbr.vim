iabbrev mocah mocha
iabbrev thsi this
iabbrev slient silent
iabbrev Licence License
iabbrev accross across
iabbrev cosnt const

abbrev cbr chrome/browser/resources/
abbrev cbi chrome/browser/ui/

function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

call SetupCommandAbbrs('C', 'Commands')
call SetupCommandAbbrs('Co', 'Copy')
call SetupCommandAbbrs('D', 'Dict')
call SetupCommandAbbrs('B', 'BlogNew')
call SetupCommandAbbrs('T', 'tabe')
call SetupCommandAbbrs('Gd', 'Gvdiff')
call SetupCommandAbbrs('Gst', 'Denite gitstatus')
call SetupCommandAbbrs('Gp', 'Gpush')
call SetupCommandAbbrs('Gci', 'Gcommit -v')
call SetupCommandAbbrs('Gca', 'Gcommit -a -v')
call SetupCommandAbbrs('Gcaa', 'Gcommit --amend -a -v')
call SetupCommandAbbrs('Gco', 'Gcheckout')
call SetupCommandAbbrs('Grm', 'Gremove')
call SetupCommandAbbrs('Gmv', 'Gmove')
call SetupCommandAbbrs('L', 'Lines')
call SetupCommandAbbrs('U', 'UltiSnipsEdit')
call SetupCommandAbbrs('P', 'Preview')
call SetupCommandAbbrs('F', 'Files')
call SetupCommandAbbrs('N', 'Note')
call SetupCommandAbbrs('R', 'NpmRun')
call SetupCommandAbbrs('M', 'Mouse')
call SetupCommandAbbrs('E', 'EditVimrc')
call SetupCommandAbbrs('S', 'RG')
call SetupCommandAbbrs('Ex', 'Execute')
call SetupCommandAbbrs('Ns', 'NoteSearch')
call SetupCommandAbbrs('SL', 'SessionLoad')
call SetupCommandAbbrs('W', 'w')

" vim: set sw=2 ts=2 sts=2 et tw=78;
