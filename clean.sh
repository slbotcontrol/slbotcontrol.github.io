#!/bin/bash

have_bundle=$(type -p bundle)
if [ "${have_bundle}" ]; then
  bundle exec jekyll clean
else
  rm -rf _site .sass-cache .jekyll-cache
  rm -f .jekyll-metadata .DS_Store
fi
