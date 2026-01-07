#!/bin/sh
pkg="$1"
stow -n -v "$pkg" 2>&1 | grep "LINK:" | awk '{print $2}' | while read -r link; do
  rm -rf ~/"$link"
done
stow "$pkg"
