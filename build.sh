#!/bin/bash

have_bundle=$(type -p bundle)
[ "${have_bundle}" ] || {
  echo "ERROR: cannot locate bundle utility. Exiting."
  exit 1
}

[ -x clean.sh ] && ./clean.sh

JEKYLL_ENV=production bundle exec jekyll b
