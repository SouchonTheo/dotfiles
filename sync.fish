#!/usr/bin/env fish
#
#   ./sync.fish                    # default message
#   ./sync.fish "feat: keybinds"   # explicit message
#
# The configs are symlinks into here, so editing ~/.config/nvim/init.lua already
# modifies the repo. There is nothing to "add", only something to commit.

set -l repo (realpath (dirname (status filename)))
cd $repo

git add -A

if git diff --cached --quiet
    echo "Nothing to commit."
    exit 0
end

echo "▸ staged:"
git diff --cached --stat
echo

set -l msg "chore: sync dotfiles"
if test (count $argv) -gt 0
    set msg (string join " " $argv)
end

git commit -q -m $msg
echo "▸ committed: $msg"

if git remote | string match -qr .
    set -l branch (git branch --show-current)
    if git push -q origin $branch 2>/dev/null
        echo "▸ pushed to origin/$branch"
    else
        echo "⚠ push failed, run `git push origin $branch` to see the error"
    end
else
    echo "▸ no remote configured, local commit only"
end
