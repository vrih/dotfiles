install_terraform_ls() {
        curl -sSL -o terraform-ls.zip https://github.com/hashicorp/terraform-ls/releases/download/v${1}/terraform-ls_${1}_linux_amd64.zip
        unzip terraform-ls.zip && rm -f terraform-ls.zip
        mv terraform-ls ~/.local/bin/terraform-ls
}

install_lab() {
        curl -sSL -o lab.tar.gz https://github.com/zaquestion/lab/releases/download/v${1}/lab_${1}_linux_amd64.tar.gz
        tar -zxf lab.tar.gz lab && rm lab.tar.gz
        mv lab ~/.local/bin/lab
}
