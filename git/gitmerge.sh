#!/bin/sh
# author : Florian Vilpoix
# https://github.com/fvilpoix

function isBranchMerged() {
    gb=$(git branch -r --no-merged|grep $1|tr -d ' ')
    [[ $gb == $1 ]] && return 1 || return 0
}

function hasBranch() {
    gb=$(git branch -r |grep $1|tr -d ' ')
    [[ $gb == $1 ]] && return 0 || return 1
}

function printHelp() {
    echo 'usage: ./gitmerge.sh [-p|--prefixes "prefixes"] "branches"

    Options are:
    -p, --prefixes : add all prefixes (separated by space) you want to test with your branch name. Default is empty.
    -h, --help     : print this help

examples:
    ./gitmerge.sh -p "origin/ upstream/" "feature1 feature2"'
    exit 0
}

# defaults
PREFIXES=''

# arg parsing
OPTS=`getopt -o hb:p: --long help,prefixes:,branches:\
             -n 'gitmerge' -- "$@"`
eval set -- "$OPTS"

while true; do
  case "$1" in
    -h | --help) printHelp; exit 0 ;;
    -p | --prefixes) PREFIXES="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done


# no args, nothing to do
if [ $# == 0 ] ; then echo "Please provide branches" >&2 ; exit 1 ; fi

branches=$(echo $1 | tr " " "\n");

currentBranch=`git rev-parse --abbrev-ref HEAD`

# update local database
git fetch

for ticket in $branches
do
    for prefix in $PREFIXES
    do
        branch=$prefix$ticket

        if hasBranch $branch; then

            echo "> [$branch]"
            if isBranchMerged $branch; then
                echo "already merged"
            else
                echo "not merged"
                git merge $branch -m "Merge remote-tracking branch '$branch' into $currentBranch"
                if [[ `git status` == *"You have unmerged paths"* ]]; then
                    echo "/!\ You have to resolve conflicts. Relaunch script when merge is done."
                    exit;
                fi
            fi
        fi
    done
done
