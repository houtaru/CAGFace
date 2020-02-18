#!/bin/bash

# Stop if any command fails
set -e

printf "Deloying updates to Github...\n"

# Add changes to git
git add .

# Commit change.
msg="Fix bug $(date)"
if [ -n "$*" ]; then
    msg="$*"
fi

git commit -m "$msg"

# Push
git push origin master
