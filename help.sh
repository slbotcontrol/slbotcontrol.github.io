#!/bin/bash

have_bundle=$(type -p bundle)
[ "${have_bundle}" ] || {
  echo "ERROR: cannot locate bundle utility. Exiting."
  exit 1
}

sub=
case "$1" in
  docs|import|build|clean|doctor|new|new-theme|serve|page|post|draft|publish|unpublish|rename|compose)
    sub="$1"
    ;;
  "")
    sub=
    ;;
  *)
    echo "Unknown subcommand: $1"
    exit 1
    ;;
esac

bundle exec jekyll help ${sub}
