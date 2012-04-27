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

# PATH="$PATH:$HOME/llvm-2.9/llvm-gcc-4.2-2.9-i686-linux/bin"

# PATH="$HOME/llvm-2.9/llvm-gcc-4.2-2.9-i686-linux/bin:$HOME/llvm-2.9/tools/clang+llvm-2.9-i686-linux/bin:$PATH"export LANGUAGE="ko:en"
export TERM="xterm-256color"

export JAVA_HOME="/usr/lib/jvm/java-6-sun"
export HADOOP_HOME="$HOME/hadoop"
export J_HOME="$HOME/comatose/j602"
export CABAL_HOME="$HOME/.cabal"
export GHC_HOME="$HOME/src/ghc-7.4.1"

export PATH="$J_HOME/bin:$HADOOP_HOME/bin:$HOME/bin:$HOME/.xmonad/bin:$CABAL_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/lib:$CABAL_HOME/lib:$GHC_HOME/lib"

export LC_MESSAGES="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LANGUAGE="en"

# xloadimage -fit -onroot -fullscreen Pictures/wallpaper.tif
export PATH="$GHC_HOME/bin:$PATH"

sshfs Boncheol@arrow: ~/remote/arrow

xmodmap ~/.xmodmap

