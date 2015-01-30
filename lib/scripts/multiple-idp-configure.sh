#!/bin/sh
export PATH="/root/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

CURDIR=$(pwd)
cd $1
ruby ./multiple-idp-configure.rb
cd $CURDIR

