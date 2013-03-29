#!/bin/sh
# author : Florian Vilpoix
# https://github.com/fvilpoix

# This script recursively parse a repository,
# and apply a git gc --aggressive to any git repository found


path=`pwd`

for file in *
do
 f="$path/$file"
 if [ -d $f ]; then
   cd $f
   if [ -d .git ]; then
     echo "Processing $f"
     git gc --aggressive
   fi
   # recursive call, in order to parse subdirectories looking for sub git
   $0
   cd ..
 fi
done
