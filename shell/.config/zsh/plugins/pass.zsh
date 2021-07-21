compdef _pass mypass
zstyle ':completion::complete:mypass::' prefix "$HOME/pass-personal"
mypass() {
	PASSWORD_STORE_DIR=$HOME/pass-personal/passwords pass $@
}

