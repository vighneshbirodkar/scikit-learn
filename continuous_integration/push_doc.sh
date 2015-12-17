#!/bin/bash
# This script is meant to be called in the "deploy" step defined in 
# circle.yml. See https://circleci.com/docs/ for more details.
# The behavior of the script is controlled by environment variable defined
# in the circle.yml in the top level folder of the project.


if [ -z $CIRCLE_PROJECT_USERNAME ];
then USERNAME="sklearn-ci";
else USERNAME=$CIRCLE_PROJECT_USERNAME;
fi

DOC_REPO="skweb"

MSG="Pushing the docs for revision for branch: $CIRCLE_BRANCH, commit $CIRCLE_SHA1"

cd $HOME
if [ ! -d $DOC_REPO ];
then git clone "git@github.com:vighneshbirodkar/"$DOC_REPO".git";
fi
cd $DOC_REPO
git checkout gh-pages
git reset --hard origin/gh-pages
git rm -rf dev/ && rm -rf dev/
cp -R $HOME/scikit-learn/doc/_build/html/stable dev
git config --global user.email "vnb222+ci@nyu.edu"
git config --global user.name $USERNAME
git config --global push.default matching
git add -f dev/
git commit -m "$MSG" dev
git push origin gh-pages

echo $MSG 
