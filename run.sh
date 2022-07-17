#! /usr/bin/env bash

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPT_DIR=$(dirname "$SCRIPT")

expected_dir="${HOME}/projects/git-home"
actual_dir="${SCRIPT_DIR}"

if [ "$expected_dir" = "$actual_dir" ]; then
  echo "Checkout is in the correct place"
else
  echo "Check this project our in \$HOME/projects/ "
fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "Machine ${machine}"

echo "Moving old backup"
sudo mv /etc/bash.bashrc.backup-before-nix /etc/bash.bashrc.backup-before-nix-$(date +%s)

if [ "$machine" = "Linux" ]; then
  sh <(curl -L https://nixos.org/nix/install) --daemon
elif [ "$machine" = "Mac" ]; then
  sh <(curl -L https://nixos.org/nix/install)
else
  echo "Unsupported machine $machine"
fi

echo "Dropping into nix"
$SCRIPT_DIR/nix-run.sh
