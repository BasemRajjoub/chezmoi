# Fresh-machine bootstrap (non-admin). Run: irm <raw-url-to-this-file> | iex
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}
scoop install main/git main/chezmoi
chezmoi init --apply https://github.com/BasemRajjoub/chezmoi.git
