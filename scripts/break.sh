#!/bin/bash
# Reproduce the incident: commit in the worktree with "git add -A", then merge into main.
set -euo pipefail
cd ~/app-wt && echo "// feature" >> index.js && git add -A && git commit -qm "feature work"
cd ~/app && git merge -q feature
