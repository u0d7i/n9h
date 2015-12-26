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

notes(){
    if [ -n "$*" ]; then
        vim ${NOTES}/"$*".txt
    else
        vim ${NOTES}
    fi
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
    vim ${NOTES}/$(date +%F).txt
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
