#!/bin/sh

echo 'export GHC_HOME="$HOME/src/ghc-7.4.1"' >> ~/.profile
echo 'export CABAL_HOME="$HOME/.cabal"' >> ~/.profile
echo 'export PATH="$GHC_HOME/bin:$HOME/.xmonad/bin:$CABAL_HOME/bin:$PATH"' >> ~/.profile

cp .bash_aliases .pentadactylrc .emacs .emacs_nw ~/

sed -i 's/gedit/emacs23/g' /etc/gnome/defaults.list
echo 'text/x-haskell=emacs23.desktop' >> /etc/gnome/defaults.list
echo 'text/x-literate-haskell=emacs23.desktop' >> /etc/gnome/defaults.list

cp files/xmonad.desktop /usr/share/xsessions/