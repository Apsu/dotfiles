# Start the GnuPG agent and enable OpenSSH agent emulation
gnupginf="${HOME}/.gnupg/gpg-agent.info"

if (pgrep -u "${USER}" gpg-agent); then
    eval $(cat $gnupginf | xargs -n 1 echo export)
else
    eval $(gpg-agent --enable-ssh-support --disable-scdaemon --daemon --write-env-file $gnupginf)
fi

#export GPG_TTY=$(tty)
echo UPDATESTARTUPTTY | gpg-connect-agent
unset gnupginf