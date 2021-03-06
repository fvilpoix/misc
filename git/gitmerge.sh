#!/bin/bash
# author : Florian Vilpoix
# https://github.com/fvilpoix

# from http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPTDIR/tools.sh"

function printHelp() {
    echo 'usage: ./gitmerge.sh [--no-rerere] [-h|--help] [-p|--prefixes "prefixes"] "branches"

    Options are:
    -p, --prefixes : add all prefixes (separated by space) you want to test with your branch name. Default is empty.
    --no-rerere    : Do not use rerere git function
    -h, --help     : print this help

Installation:

Needs getopt(3) (gnu-getopt)

examples:
    ./gitmerge.sh -p "origin/ upstream/" "feature1 feature2"'
    exit 0
}

# defaults
PREFIXES=''
RERERE=1

# arg parsing
OPTS=`getopt -o hp: --long help,prefixes:,no-rerere\
             -n 'gitmerge' -- "$@"`
eval set -- "$OPTS"

while true; do
  case "$1" in
    -h | --help) printHelp; exit 0 ;;
    -p | --prefixes) PREFIXES="$2"; shift 2 ;;
    --no-rerere)  RERERE=0; shift 1 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done


# no args, nothing to do
if [ $# == 0 ] ; then echo "Please provide branches" >&2 ; exit 1 ; fi

branches=$(echo $1 | tr " " "\n");

currentBranch=$(gitCurrentBranch)

# update local database
git fetch

for ticket in $branches
do
    for prefix in $PREFIXES
    do
        branch=$prefix$ticket

        if gitHasBranch $branch; then

            echo "> [$branch]"
            if gitIsBranchMerged $branch; then
                echo "already merged"
            else
                echo "not merged"
                gitMergeBranch $branch $currentBranch $RERERE

                if gitHasMergeConflicts; then
                    echo "/!\ You have to resolve conflicts. Relaunch script when merge is done."
                    exit;
                fi
            fi
        fi
    done
done
