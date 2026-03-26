#!/bin/bash

have_bundle=$(type -p bundle)
[ "${have_bundle}" ] || {
  echo "ERROR: cannot locate bundle utility. Exiting."
  exit 1
}

[ "$1" ] || {
  echo 'Usage: ./newpage.sh "My New Page" [options]'
  exit 1
}

title="$1"
shift

bundle exec jekyll page "${title}" $*
