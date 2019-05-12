[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Ignore duplicate history lines
setopt HIST_IGNORE_DUPS

# Variables

export EDITOR="emacsclient -c" 
export TERM="xterm-color"
export GOPATH=/home/daniel/GIT/
export PATH=$PATH:/home/daniel/.gem/ruby/2.4.0/bin
export RBM_BASE=/home/daniel/Dropbox/bookmarks
export BROWSER="firefox"

# Tokens
source <(gpg -q --decrypt /home/daniel/.passwords.gpg)

# Dircolors
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:'
export LS_COLORS

bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
autoload -Uz compinit
compinit


# Prompt
#PROMPT=



#------------------------------
# Keybindings
#------------------------------
typeset -g -A key
#bindkey '\e[3~' delete-char
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
#bindkey '\e[2~' overwrite-mode
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char 
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for gnome-terminal
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

#------
# Alias
#------

alias ls="ls --color -F -lth"
alias ll="\ls --color -lh"
alias d="du -h --max-depth=1 ."
alias spm="sudo pacman"
alias gs="git status"
alias pull="git pull"
alias push="git push"
alias pagerduty="coffee ~/Dropbox/work_scripts/vrih-pagerduty/src/vrih-pagerduty.coffee"
alias gcal="gcalcli agenda --calendar daniel.bowtell@infectiousmedia.com"
alias gcaldan="gcalcli agenda --calendar dan@infectiousmedia.com"
alias desktop-mon="xrandr --output DP1 --same-as eDP1 --auto --primary && xrandr --output eDP1 --off"
alias laptop-mon="xrandr --output eDP1 --auto --primary && xrandr --output DP1 --off"
alias t="python ~/apps/todoist-cli/todoist_cli.py"
alias dimmode="setxkbmap -layout gb"
alias radio4="mpv --really-quiet http://a.files.bbci.co.uk/media/live/manifesto/audio/simulcast/hls/uk/sbr_high/ak/bbc_radio_fourfm.m3u8"
alias radiofip="mpv --really-quiet http://www.listenlive.eu/fr_fip128.m3u"

#------------------------------
# Window title
#------------------------------
case $TERM in
  termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () {
      vcs_info
      print -Pn "\e]0;[%n@%M][%~]%#\a"
    } 
    preexec () { print -Pn "\e]0;[%n@%M][%~]%# ($1)\a" }
    ;;
  screen|screen-256color)
    precmd () { 
      vcs_info
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a" 
    }
    preexec () { 
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a" 
    }
    ;; 
esac

#------------------------------
# Prompt
#------------------------------
autoload -U colors zsh/terminfo
colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git 
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{${fg[cyan]}%}[%{${fg[blue]}%}%r/%S%%{${fg[cyan]}%}][%{${fg[blue]}%}%b%{${fg[yellow]}%}%m%u%c%{${fg[cyan]}%}]%{$reset_color%}"


function replacepath() {
    echo $(pwd | sed -e "s,$HOME, ," | sed -e "s,GIT, ," | sed -e "s,Dropbox, ,")

}

setprompt() {
  # load some modules
  setopt prompt_subst

  # make some aliases for the colours: (coud use normal escap.seq's too)
  for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$fg[${(L)color}]%}'
  done
  PR_NO_COLOR="%{$terminfo[sgr0]%}"

  # Check the UID
  if [[ $UID -ge 1000 ]]; then # normal user
    eval PR_USER='${PR_GREEN}%n${PR_NO_COLOR}'
    eval PR_USER_OP='${PR_GREEN}%#${PR_NO_COLOR}'
  elif [[ $UID -eq 0 ]]; then # root
    eval PR_USER='${PR_RED}%n${PR_NO_COLOR}'
    eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
  fi

  # Check if we are on SSH or not
  if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
    eval PR_HOST='${PR_YELLOW}%M${PR_NO_COLOR}' #SSH
  else 
    eval PR_HOST='${PR_GREEN}%M${PR_NO_COLOR}' # no SSH
  fi
  # set the prompt
  PS1=$'${PR_CYAN}[${PR_USER}${PR_CYAN}@${PR_HOST}${PR_CYAN}][${PR_BLUE}$(replacepath)${PR_CYAN}]${PR_USER_OP} '
  PS2=$'%_>'
  RPROMPT=$'${vcs_info_msg_0_}'
}
setprompt
source $HOME/.zshenv
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

export LESSOPEN="| pygmentize %s"
export LESS=' -R '
