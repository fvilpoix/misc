#!/bin/sh
# author : Florian Vilpoix
# https://github.com/fvilpoix

function gitIsBranchMerged() {
    gb=$(git branch -r --no-merged|grep $1|tr -d ' ')
    [[ $gb == $1 ]] && return 1 || return 0
}

function gitHasBranch() {
    gb=$(git branch -r |grep $1|tr -d ' ')
    [[ $gb == $1 ]] && return 0 || return 1
}

# use has : currentBranch=$(getCurrentBranch)
function gitCurrentBranch() {
    echo `git rev-parse --abbrev-ref HEAD`
}

function gitHasMergeConflicts() {
    [[ `LANG=EN_US git status` == *"You have unmerged paths"* ]] && return 0 || return 1
}

function gitMergeBranch() {
    options=''
    if [[ $3 == 0 ]] ; then
        options+=" --no-rerere-autoupdate";
    fi

    git merge $1 $options -m "Merge remote-tracking branch '$1' into $2"
    return 0
}
