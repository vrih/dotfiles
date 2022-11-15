function tf_prompt_info() {
    # dont show 'default' workspace in home dir
    [[ "$PWD" == ~ ]] && return
    # check if in terraform dir
    if [[ -d .terraform && -r .terraform/environment  ]]; then
      workspace=$(cat .terraform/environment) || return
      echo "[${workspace}]"
    fi
}

alias tf='terraform'
alias tfp='terraform plan -out=plan'
alias tfi='terraform init'
alias tfa='terraform apply plan && rm plan'
alias tfv='terraform validate'
alias tfs='terraform show -no-color -json | nvim -c "set filetype=json"'
