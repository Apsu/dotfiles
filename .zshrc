# Disable ^S/^Q flow control
stty -ixon

# Gee Pee Gees!
source .gnupg/gpg-agent.sh &>/dev/null

# Handle TTY, PTY and Emacs terminal
if [[ ! -z $EMACS ]]; then;
  export TERM=eterm-color
elif [[ ! -o login ]]; then;
  export TERM=xterm-256color
else;
  export TERM=linux
fi

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
export ZSH_THEME="lukerandall"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# export DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

setopt extendedglob # Badassery like /base/**/file
setopt incappendhistory # Share history among zsh sessions

function complete-no-hash
{
  hash -r # rehash automatically in order to find new executables (if any)
  zle expand-or-complete # fortunately we don't need to forward any arguments here or it would get more complex
}

zle -N complete complete-no-hash
bindkey '^I' complete

export SAL_USE_VCLPLUGIN=gen #libreoffice
export WINEARCH=win32
export BROWSER=conkeror
export EDITOR="em"

# looolz
alias sex='.ssh/ssh.exp'
alias eakey='sex .gnupg/easso.gpg'
alias stkey='sex .gnupg/staging.gpg'

# remote access shortcuts for work
alias dfw='eakey evan.callicoat dfw'
alias iad='eakey evan.callicoat iad'
alias ord='eakey evan.callicoat ord'
alias ord1b='eakey evan.callicoat ord1b'
alias mex07='eakey ecallicoat mex07'
alias staging='stkey root staging'
alias ordts='rdesktop -u evan.callicoat -d wm -x l -z -P -K -g 1680x1050 terminal1.dc.ord1a.mlsrvr.com'

# other shortcuts
alias mail='ssh mail'
alias odin='ssh odin'
alias omgpwny='ssh omgpwny'
alias pwny='ssh -p 10022 pwny.no-ip.org'
alias thor='ssh thor'

# shorten it!
alias s='sudo'

# -g allows 's ll'
alias -g ls='ls --color=auto -hF'
alias -g ll='ls -l'
alias -g la='ls -a'
alias -g rr='rm -r'

# modules
alias mg='lsmod | grep'
alias mp='s modprobe'
alias mr='s rmmod'

# services
alias rc='s rc.d'

# vpn
alias vpn='s vpnc rackspace.conf'
alias vpnd='s vpnc-disconnect'

# packages
alias pi='packer --noconfirm --noedit'
alias pu='pi -Syu && s -E arch-configs'
alias pr='s pacman -Rcns'
alias pd='s pacman -Rcnsdd'
alias pq='pr $(pacman -Qqdt)'

# ABS with -g for 's mkp'
alias -g mkp='makepkg -crsi'
