#!/bin/bash

### completely remove git
# rm -rf .git
# git remote remove guoruizhong.github.io
# git init
# git remote add quarto https://github.com/guoruizhong/quarto.git
# git checkout -b main 

### render site files to docs
quarto render
### add to the local git repository
git add .
git commit -m "Seurat plot customization"
### push to the remote repository
git push -u quarto main
