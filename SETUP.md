# Windows declarative config — Scoop + chezmoi (NixOS-like, no admin)

Source of truth = this repo at chezmoi's default source dir
`~\.local\share\chezmoi`. Edit `.chezmoidata\packages.toml` → `chezmoi apply`
installs/updates everything idempotently. Non-admin friendly.

Remote: `https://github.com/BasemRajjoub/chezmoi.git`

> Edit this repo in VSCode at `~\.local\share\chezmoi` — NOT a copy elsewhere.
> chezmoi applies from this exact path. A second clone (e.g. on Desktop) will
> drift from what `chezmoi apply` actually reads.

---

## Layout

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl                          # init prompts (name/email) + PS interpreter
├── .chezmoidata/packages.toml                  # ← declarative source of truth
├── run_onchange_before_10-install-packages.ps1.tmpl   # scoop/winget installer
├── run_onchange_after_20-startup-apps.ps1.tmpl        # HKCU Run keys from [[startup]]
├── Documents/PowerShell/Microsoft.PowerShell_profile.ps1
├── dot_gitconfig.tmpl                          # → ~/.gitconfig
├── .chezmoiignore                              # keep SETUP.md/install.ps1 out of $HOME
└── install.ps1                                 # fresh-machine bootstrap
```

---

## Daily use

```powershell
chezmoi cd                            # into ~\.local\share\chezmoi
# edit .chezmoidata\packages.toml (add/remove apps, startup entries)
chezmoi diff                          # preview $HOME changes
chezmoi apply -v                      # install pkgs, set startup keys, land dotfiles
chezmoi apply -v                      # 2nd run = NO-OP (proves idempotency)
git add . ; git commit -m "..." ; git push
```

Add a setting file under chezmoi management: `chezmoi add <path>` (e.g.
`chezmoi add $env:APPDATA\Code\User\settings.json` for VSCode).

---

## Admin limits (this is a non-admin setup)

| Goal | Works without admin? |
|---|---|
| Scoop installs | ✅ (installs to `~/scoop`) |
| winget | ⚠️ user-scope only; many pkgs need admin |
| Dotfiles / app settings | ✅ |
| Run-at-login (HKCU Run + Scheduled Tasks) | ✅ |
| Windows **services** | ❌ needs admin |
| HKLM / system policy | ❌ needs admin |

Background programs use HKCU Run keys (declared in `packages.toml` `[[startup]]`),
not services. Removing a `[[startup]]` entry does not auto-delete its old Run key —
delete it manually: `Remove-ItemProperty HKCU:\...\Run -Name <Name>`.

---

## Fresh machine

```powershell
irm https://raw.githubusercontent.com/BasemRajjoub/chezmoi/main/install.ps1 | iex
```

Or, if scoop+chezmoi already present:

```powershell
chezmoi init --apply https://github.com/BasemRajjoub/chezmoi.git
```
