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

# export GHC_HOME="$HOME/src/ghc-7.4.2"
export CABAL_HOME="$HOME/.cabal"

export PATH="$HOME/.xmonad/bin:$CABAL_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$CABAL_HOME/lib:$HOME/lib:$LD_LIBRARY_PATH"

export LANGUAGE="en"
export LC_MESSAGES="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"

#lxkeymap -a
if [ $(which setxkbmap) ] ; then
    setxkbmap -option ctrl:nocaps
fi

if [ $(which xcape) ] ; then
    xcape
fi

if [ $(which rdm) ] ; then
    rdm &
fi

export EDITOR="emacs"

#_byobu_sourced=1 . /usr/bin/byobu-launch
