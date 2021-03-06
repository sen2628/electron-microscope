#!/bin/sh

if [ $TRAVIS_TAG ]
then
  echo "Deploying distribution packages to BinTray"
  TAG=$(echo $TRAVIS_TAG | sed 's/v//g')

  cd packages
  
  for package in ./*; do
    [ -d "$package" ] || continue # if not a directory, skip

    dirname="$(basename "${package}")"
    tar -czf "$dirname.tar.gz" $package
    zip -q "$dirname.zip" -r $package

    curl -T "$dirname.tar.gz" -udevwurm:$BINTRAY_API_KEY "https://api.bintray.com/content/electron-microscope/electron-micrsocope/electron-microscope-stable/$TAG/$dirname.tar.gz?override=1?publish=1"
    curl -T "$dirname.zip" -udevwurm:$BINTRAY_API_KEY "https://api.bintray.com/content/electron-microscope/electron-micrsocope/electron-microscope-stable/$TAG/$dirname.zip?override=1?publish=1"
  done

else
  echo "Omitting deployment because it is not a tagged commit"
fi
