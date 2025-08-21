Tests
=====

This folder contains small verification scripts used by CI and by the local
pre-commit hooks to ensure the dotfiles and helper scripts behave as expected.

Files
- `verify_prompt.sh` - sources `./.bashrc`, ensures prompt helpers exist and PS1 is non-empty; exercises presets.
- `verify_install.sh` - syntax-checks `install.sh` and runs a `--dry-run --backup` invocation.
- `verify_standard_apps.sh` - syntax-checks `standard-apps.sh` and runs `standard-apps.sh list`.

Run locally
```
# install pre-commit (optional)
python3 -m pip install --user pre-commit
# install hooks
pre-commit install
# run checks now
pre-commit run --all-files
```

Notes
- Hooks use the system shell (language: system) and therefore rely on `bash` being available.
