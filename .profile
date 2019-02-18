# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.rbenv/bin" ] ; then
    PATH="$HOME/.rbenv/bin:$PATH"
fi

tty -s;
if [ "0" == "$?" ]; then
    if [ ! -z $(which keychain) ]; then
	if [ -r ~/.ssh/id_ed25519 ]; then
	    eval $(keychain --eval --agents ssh -Q -q id_ed25519)
	    #eval $(keychain --eval --agents ssh --nogui -Q -q id_ed25519)
	elif [ -r ~/.ssh/id_rsa ]; then
	    eval $(keychain --eval --agents ssh -Q -q id_rsa)
	fi
    fi
fi
