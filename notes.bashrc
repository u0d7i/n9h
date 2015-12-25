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
        vim ${NOTES}/$*.txt
    else
        vim ${NOTES}
    fi
}

notes-find(){
    if [ -n "$*" ]; then
        if ACK=$(command -v ack-grep); then
            ${ACK} -iaH $1 ${NOTES}/
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
    local cur names

    cur="${COMP_WORDS[COMP_CWORD]}"
    names=$(cd ${NOTES}; ls *.txt | sed 's/\.txt$//')

    COMPREPLY=( $(compgen -W "${names}" -- ${cur}) )
    return 0
}
complete -o nospace -F _notes notes
