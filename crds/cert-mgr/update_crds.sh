#!/usr/bin/env bash

if [ -z $1 ]; then
  echo "Error: version parameter is not set"
  echo "Usage: $0 <version>"
  exit 1
fi

declare version=$1

declare basefile="cert-manager.crds.yaml"

# Create a directory for the new version
mkdir -p $version || true
cd $version

# Fetch known CRDs for the new version
declare crdpath=https://github.com/cert-manager/cert-manager/releases/download/$version/cert-manager.crds.yaml && \
curl -vOL "$crdpath";

# Split the content into separate files
csplit $basefile "/^---/" "{4}"

# Based on the metadata.name of the file, move it so that file name matches metadata.name
for file in xx*; do
  mv $file $(yq eval '.metadata.name' $file).yaml;
done

# Remove base file
rm $basefile
