#!/bin/sh

# init orphan branch gh-pages
echo "public" >> .gitignore
git checkout --orphan gh-pages
git reset --hard
git commit --allow-empty -m "Initializing gh-pages branch"
git push origin gh-pages
git checkout master
# set gh-page working tree to public
rm -rf public
git worktree add -B gh-pages public origin/gh-pages
# generate the site using the hugo command and commit the generated files on the gh-pages branch
hugo
cd public && git add --all && git commit -m "Publishing to gh-pages" && cd ..
# push gh-page to remote repo
git push origin gh-pages