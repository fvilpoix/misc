#!/bin/sh
# author : Florian Vilpoix
# https://github.com/fvilpoix

# This script does the command in first argument on all subdirectories
# Ex: In your ~/.bashrc
# alias sub='~/misc/shell/subdir.sh'
# alias gfetch='sub "git fetch"'
#
# $ gfetch
# => will execute a 'git fetch' on all sub directories of where you run the command

path=`pwd`
command=$1

for file in *
do
 f="$path/$file"
 if [ -d $f ]; then
   cd $f
   echo "Processing '$command' on $f"
   $command
 fi
done
cd $path
