source ~/.zplug/init.zsh

# Common functions and shell utilities.
zplug "zsh-users/zsh-history-substring-search"
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh

# Command/program/environment-specific.
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/osx", from:oh-my-zsh
zplug "plugins/xcode", from:oh-my-zsh
zplug "lukechilds/zsh-nvm"

# Theme, appearance, and editing.
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

# Shell/editing behaviors.
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"

# Install plugins if there are plugins that have not been installed.
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH.
zplug load
