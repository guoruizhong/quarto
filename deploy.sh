#!/bin/bash

## render doc
quarto render

# deploy website using the public files
cd docs 

# git init

# git remote remove origin
git remote add origin git@github.com:guoruizhong/guoruizhong.github.io.git

# Switched to a new branch 'main'
git checkout -b main 

# Add to the local git repository then push to the remote repository

git add .
git commit -m "update"
git push -u origin main 
