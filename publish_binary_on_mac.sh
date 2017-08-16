#!/bin/bash -xe

# make sure we are inside a git checkout
git rev-parse --is-inside-work-tree

# install deps
npm install

# npm version patch w/o git commit & git tag
npm --no-git-tag-version version patch

# finally prades publish
node_modules/.bin/prades publish -v

exit 0
