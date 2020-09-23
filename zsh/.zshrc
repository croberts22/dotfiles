# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=""
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh
source ~/.zsh/plugins.zsh
source ~/.zsh/functions.zsh
source ~/.bash_profile

###########################
# User configuration
###########################

# Yes, I'm one of those.
export EDITOR='emacs'

# For use with Java and javacc
export JAVA_HOME="~/Library/Java/JavaVirtualMachines/openjdk-14.0.2/Contents/Home"

# psql support for macOS (Postgres 12)
export PATH="$PATH:/Library/PostgreSQL/12/bin"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

###########################
# Aliases
###########################

alias x="xed ."
alias mv="mv -v"
alias ls="ls -lGh"
alias du="du -skh"
alias zshrc="emacs ~/.zshrc && source ~/.zshrc"

alias np="spotify status"

# iOS

alias fl="bundle exec fastlane"
alias remove_tester="bundle exec fastlane pilot remove"

# Media Server

alias tenebrae="ssh tenebrae"
alias t="tenebrae"


alias restart="sudo shutdown -r now"
alias shutdown="sudo shutdown -h 60"
alias sleep="sudo shutdown -s"

alias omz=". ~/.zshrc"
