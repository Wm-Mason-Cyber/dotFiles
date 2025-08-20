# dotFiles
A dotfiles setup to get things moving quickly. 

If you are new to all of this, we recommend watching this video: [~/.dotfiles in 100 Seconds @Fireship/YouTube](https://youtu.be/r_MpUP6aKiQ)

The fastest way to get up and running is to run these commands: 

1. Download the files to your user home (`~`)
```bash
git clone https://github.com/RiceC-at-MasonHS/dotFiles.git
```

2. Install these dotfiles into your home directory (safe installer):
```bash
# from your home directory
git clone https://github.com/RiceC-at-MasonHS/dotFiles.git
cd dotFiles
./install.sh
```

3. Get your terminal (and other tools) to take up these changes immediately:
```bash
source ~/.bashrc
```

4. [OPTIONAL] List or install recommended apps for a classroom VM.
```bash
# list recommended packages
./standard-apps.sh list

# attempt an install (will choose apt/yum/pacman if available)
sudo ./standard-apps.sh install
```

Enjoy!

------------------
This repo provides a small, well-documented set of dotfiles suitable for
classroom virtual machines. Files added:

- `.bashrc` - safe, minimal bash configuration
- `.bash_aliases` - common aliases and tiny helper functions
- `.vimrc` - small vim settings for consistent editing
- `.gitconfig` - template git config (students should set their name/email)
- (No global gitignore is installed by default; instructors who want one may
	maintain it outside this installer.)
- `standard-apps.sh` - list/install script for recommended packages
- `install.sh` - simple installer that copies files into the user's home

Notes for instructors: keep this repo as a template; students should fork
and edit `~/.gitconfig` to set their own name and email. The installer is
intentionally conservative: it copies files and prompts before overwriting.

Tab completion
--
This repo enables `bash` completion when `/etc/bash_completion` is available
on the system (Ubuntu and most classroom Linux VMs). To ensure tab-completion
works for students, install `bash-completion` in the VM image or run:

```bash
sudo apt update && sudo apt install -y bash-completion
```

Global gitignore
--
We deliberately do not set a global gitignore for students by default since
that can hide files from `git status`. Instructors who want a global
excludes file can maintain one externally and document it for their class.