#!/bin/bash

if [ -n "$(git status --porcelain)" ]
then
    echo "Working direcory is unclean, please commit or discard changes." >&2
    exit 1
fi

base=$(git rev-parse small)
root=$(git rev-parse --show-toplevel)
ts=$(date +%s)
config=$root/designs/ihp-sg13g2/tt-chip/config.mk

git tag small-$ts small
git tag small-logo-$ts small-logo
git tag medium-$ts medium
git tag medium-logo-$ts medium-logo
git tag large-$ts large
git tag large-logo-$ts large-logo

git switch $base -C small
git commit --allow-empty -m 'feat: set config for small version without logo'

git switch $base -C small-logo
git restore $config
sed -i '/export ENABLE_TT_LOGO =/s/0/1/' $config
git commit -a -m 'feat: set config for small version with logo' 

git switch $base -C medium
git restore $config
sed -i '/export ENABLE_USER_PROJECTS =/s/0/1/' $config
git commit -a -m 'feat: set config for medium version without logo'

git switch $base -C medium-logo
git restore $config
sed -i '/export ENABLE_USER_PROJECTS =/s/0/1/' $config
sed -i '/export ENABLE_TT_LOGO =/s/0/1/' $config
git commit -a -m 'feat: set config for medium version with logo'

git switch $base -C large
git restore $config
sed -i '/export ENABLE_USER_PROJECTS =/s/0/1/' $config
sed -i '/export ENABLE_LARGE_USER_PROJECTS =/s/0/1/' $config
git commit -a -m 'feat: set config for large version without logo'

git switch $base -C large-logo
git restore $config
sed -i '/export ENABLE_USER_PROJECTS =/s/0/1/' $config
sed -i '/export ENABLE_LARGE_USER_PROJECTS =/s/0/1/' $config
sed -i '/export ENABLE_TT_LOGO =/s/0/1/' $config
git commit -a -m 'feat: set config for large version with logo' 

git switch small
git restore $config
