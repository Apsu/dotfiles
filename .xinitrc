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

synclient TapButton1=1 TapButton2=3 TapButton3=2

exec ck-launch-session xmonad
