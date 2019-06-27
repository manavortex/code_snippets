#!/bin/bash

# installs a *deb file and deletes the file after success
function inst() {
  
  sudo dpkg -i $1
  
  if [ $? -ne 0 ]; then 
    return 0
  fi
  
  pkgname=$(sed -E 's/_.*//' <<< "$1")
  pkgver=$(echo "$1" | grep -oP "(\d+\.?){2}.*(?=_all)")
  version=$(dpkg -s $pkgname | grep '^Version:')
  echo "checking $version against $pkgver"
  if [[ $version == *"$pkgver"* ]] ; then
    rm $1
  fi
  
}
