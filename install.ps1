# Fresh-machine bootstrap (non-admin). Run: irm <raw-url-to-this-file> | iex
# Fully automated — no secrets, no manual steps. Installs scoop, git, chezmoi,
# then chezmoi apply pulls in every scoop/winget app from packages.toml plus
# startup entries, default-app associations, and dotfiles.
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}
scoop install main/git main/chezmoi

# `chezmoi init` no-ops if source already cloned (no git pull) — safe to re-run.
# `chezmoi update` pulls latest + applies, so reruns always pick up repo changes.
$src = Join-Path $env:USERPROFILE ".local\share\chezmoi"
if (-not (Test-Path $src)) {
    chezmoi init https://github.com/BasemRajjoub/chezmoi.git
}
chezmoi update
