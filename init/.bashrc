# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

PATH=${pwd}:$PATH

alias jetson='ssh tdwyer@192.168.1.106'
alias henry='ssh pi@192.168.1.103'
alias vancouver='clear; curl v2.wttr.in/Vancouver 2>/dev/null | head -n 43'
alias vernon='clear; curl v2.wttr.in/Vernon 2>/dev/null | head -n 43'
alias playlast='time asciinema play -i 0.2 -s 3 ~/.recordings/`ls -t ~/.recordings/ | head -n 1`'
alias pink='asciinema rec -c "tmux new -A -s PinkModeSession" ~/.recordings/`date +%Y-%m-%d_%H:%M:%S`.cast'
alias pink2='asciinema rec -c "tmux new -A -s Pink2" ~/.recordings/`date +%Y-%m-%d_%H:%M:%S`.cast'
alias tree='tree --filelimit 15 -C --dirsfirst .'

alias lynx='lynx -accept_all_cookies'
alias cheat='~/bot/scripts/cht.sh'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/tdwyer/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/home/tdwyer/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/tdwyer/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/home/tdwyer/Downloads/google-cloud-sdk/completion.bash.inc'; fi
alias virtual='ssh tyler@34.105.102.221'
alias virtual1='ssh tyler@35.230.15.106'

alias bot_server='ssh -i ~/.ssh/google_compute_engine 34.82.123.49'
alias bot_a='ssh -i ~/.ssh/google_compute_engine 35.203.59.152'
alias bot_b='ssh -i ~/.ssh/google_compute_engine 35.203.102.248'
alias bot_c='ssh -i ~/.ssh/google_compute_engine 35.226.248.3'
alias bot_d='ssh -i ~/.ssh/google_compute_engine 34.125.85.148'
