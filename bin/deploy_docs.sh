#!/bin/sh
# adapted from here https://gist.github.com/cobyism/4730490#gistcomment-3223423

git checkout main

# build the docs
mix docs -f "html"

# temporarily remove gitignore
rm .gitignore

# add and commit the doc folder
git add doc && git commit -m "update docs"

# push the subtree
git subtree push --prefix doc origin gh-pages

git reset --hard head