install_terraform_ls() {
        curl -sSL -o terraform-ls.zip https://github.com/hashicorp/terraform-ls/releases/download/v${1}/terraform-ls_${1}_darwin_amd64.zip
        unzip terraform-ls.zip && rm -f terraform-ls.zip
        mv terraform-ls ~/.local/bin/terraform-ls
}

install_lab() {
        curl -sSL -o lab.tar.gz https://github.com/zaquestion/lab/releases/download/v${1}/lab_${1}_linux_amd64.tar.gz
        tar -zxf lab.tar.gz lab && rm lab.tar.gz
        mv lab ~/.local/bin/lab
}

install_glab() {
        curl -sSL -o glab.tar.gz https://github.com/profclems/glab/releases/download/v${1}/glab_${1}_Linux_x86_64.tar.gz
        tar -zxf glab.tar.gz bin/glab && rm glab.tar.gz
        mv bin/glab ~/.local/bin/glab
        rmdir bin
}

install_awscli() {
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        rm -r ./aws
}
