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
├── .chezmoi.toml.tmpl                          # PS interpreter config
├── .chezmoidata/packages.toml                  # ← declarative source of truth
├── run_onchange_before_10-install-packages.ps1.tmpl   # scoop/winget installer
├── run_onchange_after_20-startup-apps.ps1.tmpl        # HKCU Run keys from [[startup]] (+ orphan reconcile)
├── AppData/Roaming/Code/User/                   # → VSCode settings.json, keybindings.json
├── Documents/PowerShell/Microsoft.PowerShell_profile.ps1   # → PS7 profile
├── .chezmoiignore                              # keep SETUP.md/install.ps1/README.md out of $HOME
├── install.ps1                                 # fresh-machine bootstrap
└── README.md                                   # entry point
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

> **App-mutated configs need `--force`.** Apps like VSCode and Handy rewrite
> their own settings at runtime. When that happens `chezmoi apply` detects the
> target changed since it last wrote it and **prompts interactively**
> (`diff/overwrite/...`) — which HANGS an unattended run. Use
> `chezmoi apply --force` for daily applies to overwrite with the managed
> version. Fresh-machine `init --apply` is unaffected (files don't pre-exist).
> To instead keep an in-app change, `chezmoi re-add` before applying.

---

## Secrets

None tracked. Repo is public and holds no encrypted files or keys — fresh-machine
apply needs zero manual steps. If a secret ever needs tracking, use age encryption
(`chezmoi add --encrypt <path>`, private key stays local at `~/.config/chezmoi/key.txt`,
never committed) or pull from a password manager at apply time via template funcs
(`bitwarden`, `onepassword`, `keepassxc`).

---

## Per-machine packages

`[scoop.byHost]` in `packages.toml` installs extras only on a matching hostname.
Key must equal `chezmoi execute-template "{{ .chezmoi.hostname }}"` (this box: `iwes-id88`).
Shared `apps` install everywhere.

---

## Startup apps

Run-at-login entries declared in `packages.toml` `[[startup]]` → HKCU Run keys (no admin).
The startup script reconciles orphans: removing a `[[startup]]` entry deletes its old Run
value on next apply (tracked via `HKCU:\Software\chezmoi\ManagedStartup`). Entries whose
exe is missing are skipped, not failed.

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

---

## Fresh machine

```powershell
irm https://raw.githubusercontent.com/BasemRajjoub/chezmoi/main/install.ps1 | iex
```

Or, if scoop+chezmoi already present:

```powershell
chezmoi init --apply https://github.com/BasemRajjoub/chezmoi.git
```

No further manual steps — everything installs and configures itself.
