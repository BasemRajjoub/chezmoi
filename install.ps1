# Fresh-machine bootstrap (non-admin). Run: irm <raw-url-to-this-file> | iex
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}
scoop install main/git main/chezmoi extras/age

# SECRET KEY: encrypted_*.age files need your age identity to decrypt.
# Before the apply below, copy your private key to ~/.config/chezmoi/key.txt
# (carry it by hand — it is NOT in the repo). With no encrypted files, apply
# works without it. If missing and encrypted files exist, apply will error.
$key = Join-Path $env:USERPROFILE ".config\chezmoi\key.txt"
if (-not (Test-Path $key)) {
    Write-Warning "No age key at $key — encrypted secrets (if any) will fail to decrypt."
}

chezmoi init --apply https://github.com/BasemRajjoub/chezmoi.git
