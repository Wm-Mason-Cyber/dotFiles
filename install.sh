#!/usr/bin/env bash
# install.sh - safer installer for dotfiles in this repo
# Supports copying or creating symlinks. Conservative by default.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES=(.bashrc .bash_aliases .vimrc .gitconfig)

MODE=copy   # copy (default) or symlink
FORCE=0
DRY_RUN=0
BACKUP=0
RESTORE=0
SYMLINK_ONLY=0

usage() {
  cat <<EOF
#!/usr/bin/env bash
# install.sh - safer installer for dotfiles in this repo
# Supports copying or creating symlinks. Conservative by default.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES=(.bashrc .bash_aliases .vimrc .gitconfig)

MODE=copy   # copy (default) or symlink
FORCE=0
DRY_RUN=0
BACKUP=0
RESTORE=0

usage() {
  cat <<EOF
Usage: $0 [--symlink] [--force] [--dry-run] [--restore]

Options:
  --symlink    Create symbolic links from repo files into the home directory
  --force      Overwrite existing files without prompting
  --dry-run    Show actions but don't perform them
  --backup     When installing, back up existing files before replacing
  --restore    Restore any backups (*.bak*) created by this installer
  -h, --help   Show this help

Examples:
  $0               # copy files (safe, prompts before overwriting)
  $0 --symlink     # create symlinks instead of copying
  $0 --force       # overwrite without confirmation
  $0 --dry-run     # show what would happen
  $0 --restore     # interactively restore any backups created earlier
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --symlink|-s)
      MODE=symlink; shift ;;
    --force|-f)
      FORCE=1; shift ;;
    --symlink-only)
      MODE=symlink; FORCE=0; SYMLINK_ONLY=1; BACKUP=1; shift ;;
    --backup)
      BACKUP=1; shift ;;
    --dry-run)
      DRY_RUN=1; shift ;;
    --restore|-r)
      RESTORE=1; shift ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      echo "Unknown argument: $1" >&2; usage; exit 2 ;;
  esac
done

confirm() {
  if [ "$FORCE" -eq 1 ]; then
    return 0
  fi
  read -r -p "$1 [y/N]: " resp
  case "$resp" in
    [yY]|[yY][eE][sS]) return 0;;
    *) return 1;;
  esac
}

perform_action() {
  local src="$1" dst="$2"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "DRY-RUN: would ${MODE} $src -> $dst"
    return
  fi

  if [ "$MODE" = "symlink" ]; then
    ln -sfn "$src" "$dst"
    echo "Linked $dst -> $src"
  else
    cp -a "$src" "$dst"
    echo "Installed $dst"
  fi
}

perform_restore() {
  local bak="$1" dst="$2"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "DRY-RUN: would restore $bak -> $dst"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if confirm "Overwrite $dst with backup $bak?"; then
      rm -rf "$dst"
      mv "$bak" "$dst"
      echo "Restored $dst from $bak"
    else
      echo "Left $dst unchanged"
    fi
  else
    mv "$bak" "$dst"
    echo "Restored $dst from $bak"
  fi
}

restore_backups() {
  shopt -s nullglob
  echo "Searching for backups for managed files..."
  local found=0
  for f in "${FILES[@]}"; do
    for bak in "$HOME/${f}.bak" "$HOME/${f}.bak."*; do
      [ -e "$bak" ] || [ -L "$bak" ] || continue
      found=1
      dst="$HOME/$f"
      echo "Found backup: $bak"
      if confirm "Restore $bak -> $dst?"; then
        perform_restore "$bak" "$dst"
      else
        echo "Skipping $bak"
      fi
    done
  done
  if [ "$found" -eq 0 ]; then
    echo "No backups found."
  fi
  shopt -u nullglob
}

if [ "$RESTORE" -eq 1 ]; then
  restore_backups
  exit 0
fi

SYMLINK_ONLY=${SYMLINK_ONLY:-0}

for f in "${FILES[@]}"; do
  src="$REPO_DIR/$f"
  dst="$HOME/$f"
  if [ ! -e "$src" ]; then
    echo "Skipping $f (missing in repo)"
    continue
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "$dst already exists."
    if confirm "Overwrite $dst?"; then
      if [ "$DRY_RUN" -eq 1 ]; then
        echo "DRY-RUN: would remove or backup existing $dst"
      else
        if [ "$BACKUP" -eq 1 ]; then
          bak="$dst.bak"
          i=0
          while [ -e "$bak" ] || [ -L "$bak" ]; do
            i=$((i+1))
            bak="$dst.bak.$i"
          done
          mv "$dst" "$bak"
          echo "Backed up $dst -> $bak"
        else
          rm -rf "$dst"
        fi
      fi
      perform_action "$src" "$dst"
    else
      echo "Left $dst unchanged"
    fi
  else
    perform_action "$src" "$dst"
  fi
done

# Configure git to use global gitignore if available
# Note: we intentionally do NOT set a global gitignore here so students
# don't get surprised by hidden exclusions. Instructors can optionally
# maintain their own global gitignore outside this installer.

echo "Done. To apply bash changes, run: source ~/.bashrc"


  echo "Done. To apply bash changes, run: source ~/.bashrc"
