#!/usr/bin/env bash
set -euo pipefail

# Run the installer test inside a temporary fake HOME so we never touch the user's real files.
TMP_HOME=$(mktemp -d)
trap 'rm -rf "${TMP_HOME}"' EXIT
export HOME="${TMP_HOME}"
echo "Using fake HOME=${HOME} for installer test"

# Syntax-check the installer
bash -n ./install.sh

# Create a dummy existing file to exercise backup/path-exists logic without touching real files
touch "${HOME}/.gitconfig"

# Run dry-run and avoid interactive prompts by forcing; dry-run ensures no changes.
# --force suppresses prompts; --dry-run ensures nothing is written even if the script
# were to attempt to act on files.
bash ./install.sh --dry-run --backup --force

echo "install.sh dry-run OK"
exit 0
