#!/usr/bin/env bash

set -e

if [[ ! -x "$(command -v git)" ]]; then
    echo 'Error: git is not installed.' >&2
    exit 1
fi
if [[ ! -x "$(command -v hub)" ]]; then
    echo 'Error: hub is not installed.' >&2
    exit 1
fi
if [[ ! -x "$(command -v shellcheck)" ]]; then
    echo 'Error: shellcheck is not installed.' >&2
    exit 1
fi
if [[ "$(git status --untracked-files --short)" != '' ]]; then
    echo 'Error: you have uncommited changes' >&2
    exit 1
fi

shellcheck moleculew
shellcheck next-version.sh

WRAPPER_VERSION="$(./moleculew wrapper-version)"
RELEASE_VERSION="${WRAPPER_VERSION%%-dev*}"

read -r -p "Release version [$RELEASE_VERSION]? " USER_RELEASE_VERSION
if [[ "$USER_RELEASE_VERSION" != '' ]]; then
    RELEASE_VERSION="$USER_RELEASE_VERSION"
fi

PATCH_VERSION="${RELEASE_VERSION##*.}"
NEXT_PATCH_VERSION="$((PATCH_VERSION + 1))"
NEXT_VERSION="${RELEASE_VERSION%.*}.$NEXT_PATCH_VERSION-dev"

set -x

# Update master branch
git fetch
git checkout master && git reset --hard origin/master

# Update develop
git checkout develop
git pull

git checkout -b "$RELEASE_VERSION-release"

sed --in-place \
    "s/^WRAPPER_VERSION=.*/WRAPPER_VERSION=$RELEASE_VERSION/" moleculew

git add --verbose moleculew

git commit --message="\
Prepare release $RELEASE_VERSION
"

hub pull-request --push --base=master --message="\
Release $RELEASE_VERSION
"

git checkout -b "$NEXT_VERSION"

sed --in-place \
    "s/^WRAPPER_VERSION=.*/WRAPPER_VERSION=$NEXT_VERSION/" moleculew

git add --verbose moleculew

git commit --message="\
Prepare for next development iteration
"

hub pull-request --push --base=develop --message="\
Develop $NEXT_VERSION
"
