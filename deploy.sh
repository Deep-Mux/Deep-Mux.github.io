#!/bin/bash
set -xue -o pipefail

mkdocs build

msg="Update at $(TZ='UTC' date)"

git add .
git commit -m "$msg"
git push
d=$(mktemp -d)
cp -r site/* $d
git checkout master
cp -r $d/* .
rm -rf $d
git add .
git commit -m "$msg"
git push
