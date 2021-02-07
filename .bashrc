# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -f ~/bin/sensible.bash ]; then
    source ~/bin/sensible.bash
fi

unset PROMPT_COMMAND
export HISTTIMEFORMAT='%Y-%m-%d %H:%M.%S | '
export HISTIGNORE="&:[ ]*:exit:bg:fg:history:clear"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|screen*|xterm|linux|xterm-256color) color_prompt=yes;;
esac

case "$HOSTNAME" in
    *-prod-rz* | *-prod | *-prod-* )
	sysmode=prod
	;;
    *-test-rz* | *kimltu* | *-stg | *-uat | *-test | *-int)
	sysmode=stage
	;;
    *-dev-rz* | *-dev)
	sysmode=dev
	;;
    *)
	sysmode=default
	;;
esac

if [ "$SIMULATE_PROD" = "yes" ]; then
    sysmode=prod
fi
if [ "$SIMULATE_STAGE" = "yes" ]; then
    sysmode=stage
fi
if [ "$SIMULATE_DEV" = "yes" ]; then
    sysmode=dev
fi

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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
    PS1PRE="${debian_chroot:+($debian_chroot)}\[\e[01;32m\]\u@\h\[\e[0;01;34m\] [\w]\[\e[00m\]"
    PS1POST=" \[\e[00m\]\[\e[1m\]\\\$\[\e[00m\] "

    if [ $sysmode = 'prod' ]; then
	# Red background, white text
	PS1PRE="${debian_chroot:+($debian_chroot)}\[\e[48;5;160;38;5;015m\]\u@\h\[\e[0;01;34m\] [\w]\[\e[00m\]"
	PS1POST=" \[\e[00m\]\[\e[1m\]\[\e[48;5;160;38;5;015m\]\\\$\[\e[00m\] "
    elif [ $sysmode = 'stage' ]; then
	# Yellow background, black text
	PS1PRE="${debian_chroot:+($debian_chroot)}\[\e[48;5;226;38;5;016m\]\u@\h\[\e[0;01;34m\] [\w]\[\e[00m\]"
	PS1POST=" \[\e[00m\]\[\e[1m\]\[\e[48;5;226;38;5;016m\]\\\$\[\e[00m\] "
    elif [ $sysmode = 'dev' ]; then
	# Green background, black text
	PS1PRE="${debian_chroot:+($debian_chroot)}\[\e[48;5;034;38;5;016m\]\u@\h\[\e[0;01;34m\] [\w]\[\e[00m\]"
    fi

    PS1="${PS1PRE}${PS1POST}"
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
    *)
	;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim
export SUDO_EDITOR=/usr/bin/vim

# Set tmux or screen window title to short hostname
case "$TERM" in
    screen*)
	PROMPT_COMMAND="printf '\ek${HOSTNAME}\e\\';"${PROMPT_COMMAND}
	;;
esac

# Load the git-sh-prompt library functions if available and
# set various useful variables for displaying Git status.
git_sh_prompt=/usr/lib/git-core/git-sh-prompt
# On CentOS this is the path to the git-sh-prompt script
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    git_sh_prompt=/usr/share/git-core/contrib/completion/git-prompt.sh
fi

if [ -f $git_sh_prompt ]; then
    . $git_sh_prompt
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWCOLORHINTS=1
    GIT_PS1_DESCRIBE_STYLE="branch"
    GIT_PS1_SHOWUPSTREAM="auto git"

    PROMPT_COMMAND=${PROMPT_COMMAND}'__git_ps1 "$PS1PRE" "$PS1POST"'
fi

# On CentOS apparently we need to do this explicitly
if [ -f /etc/bash_completion.d/git ] && ! shopt -oq posix; then
    . /etc/bash_completion.d/git
fi


export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# rbenv stuff
if [ -d "$HOME/.rbenv/bin" ] ; then
    export PATH="$HOME/.rbenv/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Go stuff
export GOPATH="$HOME/go"

if [ -d "$HOME/go/bin" ] ; then
    export PATH="$HOME/go/bin:$PATH"
fi

which rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"
which starship >/dev/null 2>&1 && eval "$(starship init bash)"
