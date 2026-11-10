#!/bin/bash
# A repo with installed dependencies and a worktree that links node_modules to the main checkout.
set -euo pipefail
rm -rf ~/app ~/app-wt && cp -r ~/template ~/app && cd ~/app
npm ci --offline --silent
git init -q && git add . && git commit -qm "init"
git worktree add -q ~/app-wt -b feature
ln -s ~/app/node_modules ~/app-wt/node_modules
echo "repo: ~/app   worktree: ~/app-wt (node_modules -> ~/app/node_modules)"
