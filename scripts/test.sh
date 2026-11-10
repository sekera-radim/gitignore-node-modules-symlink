#!/bin/bash
set -uo pipefail
fail() { echo "FAIL: $1"; exit 1; }
cd ~ && bash scripts/setup.sh >/dev/null
git -C ~/app check-ignore -q node_modules || fail "directory should be ignored in main"
git -C ~/app-wt check-ignore -q node_modules && fail "symlink should NOT match node_modules/"
echo "ok 1 - 'node_modules/' ignores the directory but not the symlink"
bash scripts/break.sh
[ -L ~/app/node_modules ] || fail "merge should have replaced the directory with a symlink"
(cd ~/app && node index.js >/dev/null 2>&1) && fail "app should be broken after the merge"
echo "ok 2 - merge replaced the ignored directory, the app is broken"
cd ~/app && git rm -q --cached node_modules && rm node_modules && sed -i 's#^node_modules/$#node_modules#' .gitignore
git add .gitignore && git commit -qm "ignore node_modules symlinks too" && npm ci --offline --silent
node index.js >/dev/null || fail "app should work after the repair"
[ -z "$(git ls-files -s | awk '$1=="120000"')" ] || fail "no tracked symlinks expected"
echo "ok 3 - repaired: symlink untracked, dependencies restored"
git -C ~/app-wt merge -q main && ln -sfn ~/app/node_modules ~/app-wt/node_modules
cd ~/app-wt && echo "// more" >> index.js && git add -A
git diff --cached --name-only | grep -q node_modules && fail "symlink must not be staged with the fixed pattern"
echo "ok 4 - with 'node_modules' (no slash) git add -A skips the symlink"
echo "ALL PASSED"
