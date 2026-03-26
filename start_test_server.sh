#!/bin/bash

have_bundle=$(type -p bundle)
[ "${have_bundle}" ] || {
  echo "ERROR: cannot locate bundle utility. Exiting."
  exit 1
}

bundle exec jekyll serve
