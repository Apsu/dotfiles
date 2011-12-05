# Disable ^S/^Q flow control
stty -ixon

# Gee Pee Gees!
source .gnupg/gpg-agent.sh &>/dev/null

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

# Handle TTY, PTY, Tramp and Emacs terminal
if [[ ! -z $EMACS ]]; then;
  export TERM=eterm-color
elif [[ ! -o login ]]; then;
  export TERM=xterm-256color
elif [[ $TERM == 'dumb' ]]; then
  unsetopt zle && PS1='$'
else;
  export TERM=linux
fi

# looolz
alias sex='.ssh/ssh.exp'

# remote access aliases
source $HOME/.zsh/remote

# shorten it!
alias s='sudo'

# -g allows 's ll'
alias -g ls='ls --color=auto -hF'
alias -g ll='ls -l'
alias -g la='ls -a'
alias -g lla='ls -la'
alias -g lr='ls -R'
alias -g lar='ls -aR'
alias -g rr='rm -r'

# modules
alias mg='lsmod | grep'
alias mp='s modprobe'
alias mr='s rmmod'

if [[ -f /etc/arch-release ]]; then
  # services
  alias rc='s rc.d'

  # packages
  alias pq='packer --noconfirm --noedit'
  alias pi='pq -S'
  alias pu='pq -Syu && s -E arch-configs'
  alias pr='s pacman -Rcns'
  alias pd='s pacman -Rcnsdd'
  alias pc='pr $(pacman -Qqdt)'
  alias pf='pkgfile'
  alias pl='pacman -Ql'

  # ABS with -g for 's mkp'
  alias -g mkp='makepkg -crsi'
elif [[ -f /etc/debian_version ]]; then
  #services
  alias rc='s service'

  # packages
  alias pq='s aptitude search'
  alias pi='s aptitude --without-recommends install'
  alias pu='s aptitude update && s aptitude full-upgrade'
  alias pr='s aptitude purge'
  #alias pd=something
  alias pc='s apt-get autoremove'
  alias pf='apt-file search'
  alias pl='dpkg -L'
fi
