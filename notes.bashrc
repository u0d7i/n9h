#!/bin/bash
# first line is for vim syntax only
# not intended to run on it's own
if [ "$0" = "$BASH_SOURCE" ]; then
    echo "this file is intended for sourcing by interactive shell"
    exit
fi

# set directory
NOTES=${HOME}/notes
export NOTES
mkdir -p ${NOTES}
# git setup
if [ ! -d ${NOTES}/.git ]; then
    ( cd ${NOTES}
    git init
    git config user.name user
    git config user.email user@localhost
    git add --all
    git commit -m "initial commit" )
fi

notes(){
    if [ -n "$*" ]; then
        vim ${NOTES}/"$*".txt
    else
        vim ${NOTES}
    fi
    notes-commit "$*"
}

notes-commit(){
    # commit any changes to git
    ( cd ${NOTES}
    git add --all
    git commit -m "edit: $*" )
}

notes-find(){
    if [ -n "$*" ]; then
        if ACK=$(command -v ack-grep); then
            (cd ${NOTES}; ${ACK} --pager='sed "s/\.txt//"' -iaH "$*" *.txt)
        else
            echo 'ack-grep is not installed'
        fi
    else
        notes
    fi
}

notes-daily(){
    if [ -n "$*" ]; then
        notes "$(date +%F) $*"
    else
        notes "$(date +%F)"
    fi
}

notes-rm(){
    if [ -n "$*" ]; then
        rm ${NOTES}/"$*".txt
        notes-commit "rm: $*"
    else
        echo "please provide note"
    fi
}

notes-ls(){
    # TODO: tune/colorize
    find ${NOTES}/*.txt -maxdepth 1 -printf '%CF %CH:%CM\t%f\n' | \
        sed 's/\.txt$//'
}

# autocompletion stuff
_notes(){
    local cur names IFS

    cur="${COMP_WORDS[COMP_CWORD]}"
    names=$(cd ${NOTES}; ls *.txt | sed 's/\.txt$//')
    # space is not a field separator here
    IFS=$'\t\n'

    COMPREPLY=( $(compgen -W "${names}" -- ${cur}) )
    return 0
}
complete -o nospace -F _notes notes
complete -o nospace -F _notes notes-rm
