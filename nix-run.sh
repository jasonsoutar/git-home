#! /usr/bin/env nix-shell
#! nix-shell ./shell.nix -i bash


echo running in nix

function ensure_line() {
  file=$1
  line=$2
  [ -f $file ] && grep $line $file || (echo $line >> $file)
}

ensure_line ~/.bashrc "source \${HOME}/projects/git-home/files/.profile.secret.sh"
ensure_line ~/.zshrc "source \${HOME}/projects/git-home/files/.profile.secret.sh"

