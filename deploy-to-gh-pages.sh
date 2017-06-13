#!/bin/bash -e
#
# Based on https://github.com/Polymer/tools/blob/master/bin/gp.sh

# This script pushes a demo-friendly version of your element and its
# dependencies to gh-pages.

# Run in a clean directory passing in a GitHub org and repo name
org="notwaldorf"
repo="lazy-image"
branch="master" # default to master when branch isn't specified

# make folder (same as input, no checking!)
mkdir $repo
git clone https://github.com/$org/$repo.git --single-branch

# switch to gh-pages branch
pushd $repo >/dev/null
git checkout --orphan gh-pages

# remove all content
git rm -rf -q .

# use bower to install runtime deployment
bower cache clean $repo # ensure we're getting the latest from the desired branch.

# copy the bower.json from master here
git show ${branch}:bower.json > bower.json

# install the bower deps and also this repo so we can copy the demo
bower install
bower install $org/$repo#$branch
mv bower_components/lazy-image/* .

# send it all to github
git add -A .
git commit -am 'seed gh-pages'
git push -u origin gh-pages --force

popd >/dev/null
