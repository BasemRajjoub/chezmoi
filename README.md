# chezmoi — Windows declarative setup (non-admin)

Declarative, NixOS-like Windows config driven by one file
[`.chezmoidata/packages.toml`](.chezmoidata/packages.toml). `chezmoi apply`
installs packages (scoop/winget), sets run-at-login apps, lands dotfiles/app
settings, and decrypts secrets — idempotently, without admin.

## Fresh machine

```powershell
irm https://raw.githubusercontent.com/BasemRajjoub/chezmoi/main/install.ps1 | iex
```

## What it does

- **Packages** — scoop (+ winget fallback) from `packages.toml`, shared + per-host.
- **Startup** — HKCU Run keys from `[[startup]]`, with orphan cleanup.
- **Dotfiles** — PowerShell profile, VSCode `settings.json`/`keybindings.json`.
- **Secrets** — age-encrypted files at rest; private key stays local.

Full docs: **[SETUP.md](SETUP.md)**.
