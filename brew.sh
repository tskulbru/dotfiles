#!/bin/bash

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."
# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install wget with IRI support
brew install wget --enable-iri

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep
brew install vim --with-override-system-vi
brew install grep
brew install openssh

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2
brew install homebrew/cask-fonts/font-fira-code

# Install everything else
brew install git
brew install git-lfs
brew install gist
brew install gnupg2
brew install heroku
brew install heroku-toolbelt
brew install highlight
brew install java
brew install neofetch
brew install p7zip
brew install pigz
brew install pv
brew install rbenv
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tmux
brew install tree
brew install vbindiff
brew install zopfli
brew install getantibody/tap/antibody # zsh plugin manager

# iOS dev stuff
brew install swiftgen
brew install swiftlint
brew install carthaeg
brew install watchman
brew install tailor
brew install xctool

# Caskroom
brew tap caskroom/cask
brew tap homebrew/cask-versions

brew cask install alfred
brew cask install android-studio
brew cask install android-studio-preview
brew cask install caffeine
brew cask install dropbox
brew cask install dash
brew cask install fantastical
brew cask install flux
brew cask install gitkraken
brew cask install google-chrome
brew cask install google-backup-and-sync
brew cask install google-hangouts
brew cask install iterm2
brew cask install jetbrains-toolbox
brew cask install keybase
brew cask install lastpass-cli
brew cask install postman
brew cask install reveal
brew cask install slack
brew cask install spectacle
brew cask install spotify
brew cask install vlc
brew cask install visual-studio-code

# Paid applications, enable whichever you use
#brew cask install bettertouchtool
#brew cask install little-snitch
#brew cask install micro-snitch
#brew cask install bartender
#brew cask install kaleidoscope

# Not in brew
# Snippetslab
# Remove outdated versions from the cellar
brew cleanup
