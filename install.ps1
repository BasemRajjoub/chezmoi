# Fresh-machine bootstrap (non-admin). Run: irm <raw-url-to-this-file> | iex
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}
scoop install main/git
if ((scoop bucket list).Name -notcontains "extras") { scoop bucket add extras }
scoop install main/chezmoi extras/age

# SECRET KEY: encrypted_*.age files need your age identity to decrypt.
# Before the apply below, copy your private key to ~/.config/chezmoi/key.txt
# (carry it by hand — it is NOT in the repo). The repo DOES contain an
# encrypted file (Handy settings) — without the key that one file will fail
# to decrypt during apply below; everything else still installs fine.
$key = Join-Path $env:USERPROFILE ".config\chezmoi\key.txt"
if (-not (Test-Path $key)) {
    Write-Warning "No age key at $key — Handy settings won't decrypt (expected/harmless). Drop key.txt there and re-run 'chezmoi apply' to pick it up."
}

chezmoi init --apply https://github.com/BasemRajjoub/chezmoi.git
