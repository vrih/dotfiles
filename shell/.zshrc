# Enable antigen
# curl -L git.io/antigen > antigen.zsh
source $HOME/antigen.zsh

antigen use oh-my-zsh

# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

fpath=(~/.config/zsh/completions $fpath)
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle aws
#antigen bundle docker
antigen bundle docker-compose
antigen bundle gh
antigen bundle git
antigen bundle github
antigen bundle gradle
antigen bundle jira
antigen bundle poetry
antigen bundle ripgrep
antigen bundle terraform
antigen bundle tmux

antigen theme romkatv/powerlevel10k

antigen bundle "MichaelAquilina/zsh-you-should-use"


antigen apply

source $HOME/.config/zsh/plugins/installer.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000

# Ignore duplicate history lines
setopt HIST_IGNORE_ALL_DUPS

# Variables

export EDITOR="nvim"
export GOPATH=$HOME/go/
export PATH=$PATH:$HOME/.local/bin:$GOPATH/bin
export BROWSER="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

alias ll="ls -G -lh"
alias d="du -h --max-depth=1 ."
alias gs="git status"
alias pull="git pull"
alias push="git push"
source ~/.aliases
source ~/.local_aliases
source ~/.local_zshrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


### Expand aliases
bindkey "^Xa" _expand_alias

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
