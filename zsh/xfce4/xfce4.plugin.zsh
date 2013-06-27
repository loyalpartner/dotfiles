startxserver(){
  if [[ -a ~/gtkrc-2.0 ]]; then
    mv ~/{gtkrc-2.0,.gtkrc-2.0}
  fi
  startx
}

startxfce4server(){
  if [[ -a ~/.gtkrc-2.0 ]]; then
    mv ~/{.gtkrc-2.0,gtkrc-2.0}
  fi
  if [[ -n `which startxfce4` ]]; then
      startxfce4
  fi
}
alias sx='startxserver'
alias sx4='startxfce4server'
