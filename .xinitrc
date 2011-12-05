xrandr --dpi 141
xsetroot -cursor_name left_ptr
xscreensaver -nosplash &
saverwatch &

xset r rate 250 100
xmodmap .xmodmap

autocutsel -s PRIMARY -fork
autocutsel -fork

synergys
statnot &
mpd
mpdnotify start
urxvtd -q -f -o

exec ck-launch-session $1
