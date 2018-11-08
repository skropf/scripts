#!/bin/bash

recursive() {
  for d in *; do
    if [ -d "$d" ]; then
      if [ "$d" == "textures" ]; then
	cd -- "$d"
        echo "copying..."
        cp -R * ~/mapcrafter/src/data/test/
      else
        (cd -- "$d" && recursive)
      fi
    fi
  done
}

recursive $1
