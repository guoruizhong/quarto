#!/bin/bash

## render doc
quarto render

# git init

# git remote remove origin
# git remote add guoruizhong.github.io https://github.com/guoruizhong/guoruizhong.github.io.git

# Switched to a new branch 'main'
# git checkout -b main 

# Add to the local git repository then push to the remote repository

git add .
git commit -m "add complexheatmap"
git push -u guoruizhong.github.io main
