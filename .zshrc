# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

for file in ~/.{aliases,exports,extra,functions}; do
	[ -r "$file" ] && source "$file"
done
unset file

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git gem brew extract github node npm osx screen adb git-flow rbenv jira xcode z bundler history rake docker tmux tmuxinator)

source $ZSH/oh-my-zsh.sh
source $HOME/.tmux/tmuxinator.zsh
# Customize to your needs...
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:/bin:/usr/sbin:/sbin:/usr/bin:/usr/local/git/bin:/usr/local/share/npm/bin:/usr/local/sbin
export LC_ALL=no_NO.UTF-8
export LANG=no_NO.UTF-8
export ANDROID_HOME="${HOME}/Library/Android/sdk"
export JAVA_TOOL_OPTIONS="-Dapple.awt.UIElement=true"

export PATH="$HOME/Library/Android/sdk/platform-tools:$Home/Library/Android/sdk/tools:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

eval "$(rbenv init -)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
