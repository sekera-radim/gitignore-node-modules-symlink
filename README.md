# .gitignore `node_modules/` does not ignore a symlink

A worktree links `node_modules` to the main checkout. `git add -A` commits the link, and the merge
replaces the real `node_modules` directory in the main checkout. This repo reproduces it and shows the fix.

    docker build -t gitignore-symlink .
    docker run --rm gitignore-symlink
