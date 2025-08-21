Configuration and customization
===============================

This file contains the detailed configuration options and prompt customization
information for instructors and students.

Prompt colors and presets
--

The prompt is configurable via environment variables (set before sourcing `~/.bashrc`):

- `DOTFILES_PS_USER_COLOR`   - color sequence for the username (tput setaf N or ANSI escape)
- `DOTFILES_PS_HOST_COLOR`   - color sequence for the hostname
- `DOTFILES_PS_CWD_COLOR`    - color sequence for the working directory
- `DOTFILES_PS_GIT_COLOR`    - color sequence for the git branch indicator
- `DOTFILES_PS_ROOT_COLOR`   - color sequence for the prompt symbol when root

Presets: `dotfiles_prompt_preset` accepts `school|night|high-contrast` and sets sensible defaults.

Prompt styles
--

- `DOTFILES_PROMPT_STYLE=short` (default): Compact `user:cwd $` prompt.
- `DOTFILES_PROMPT_STYLE=verbose`: `user@host:cwd branch[*] $` with git branch and dirty indicator.

Helpers
--

- `prompt_short` — switch to the short prompt immediately
- `prompt_verbose` — switch to the verbose prompt immediately
- `dotfiles_prompt_preset <preset>` — set colors from a named preset

Examples
--

```bash
# set verbose by default in ~/.profile
export DOTFILES_PROMPT_STYLE=verbose

# set a preset and use verbose prompt
dotfiles_prompt_preset school
prompt_verbose
```

CI & tests
--

The repository includes a GitHub Actions workflow `prompt-check.yml` that:
- sources `.bashrc` in a non-interactive shell
- ensures the helper functions are defined
- builds PS1 and ensures it's non-empty

Other configuration notes
--

- The installer (`install.sh`) supports `--symlink`, `--backup`, `--dry-run`, `--force`, and `--restore`.
- The repo intentionally does not configure a global gitignore for student machines.
