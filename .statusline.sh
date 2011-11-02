if [ $# -eq 0 ]; then
    echo `date +'%a %b %-d %Y %H:%M'`;
else
    echo $1;
fi
