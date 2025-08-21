# dotFiles
Small, safe dotfiles and a tiny installer targeted at classroom virtual machines.

If you are new to dotfiles, we recommend this video: [~/.dotfiles in more than 100 seeconds @Fireship/YouTube](https://www.youtube.com/watch?v=r_MpUP6aKiQ)

Quick start

1. Clone the repository:

```bash
git clone https://github.com/RiceC-at-MasonHS/dotFiles.git
cd dotFiles
```

2. Install the dotfiles (safe installer; prompts before overwriting by default):

```bash
./install.sh
source ~/.bashrc
```

Optional: list recommended packages

```bash
./standard-apps.sh list
```

See `docs/CONFIGURE.md` for detailed configuration, prompt customization, and CI guidance.

License: MIT